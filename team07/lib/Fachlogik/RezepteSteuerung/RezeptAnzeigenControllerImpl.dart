
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDeinkaufsliste.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDgekochtesRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorie.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDschritt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutats_Menge.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/rezept.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat_Rezeptanzeige.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';
import '../../Datenhaltung/DatenhaltungsAPI/ICRUDkategorieRezeptZuordnung.dart';
import '../../Datenhaltung/DatenhaltungsAPI/ICRUDnaehrwerte_pro_100g.dart';
import '../../Datenhaltung/DatenhaltungsAPI/gekochtesRezept.dart';
import '../../Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';
import '../SteuerungsAPI/Naehrwerte.dart';
import '../SteuerungsAPI/RezeptAnzeigenController.dart';
import '../SteuerungsAPI/Schritte_Rezeptanzeige.dart';

class RezeptAnzeigenControllerImpl implements RezeptAnzeigenController {
  ///Zugriffspunkt auf RezepteGUI in Datenbank
  ICRUDRezept rezeptSchnittstelle = getIt<ICRUDRezept>();

  ///Zugriffspunkt auf Schritt in Datenbank
  ICRUDschritt schrittSchnittstelle = getIt<ICRUDschritt>();

  /// Zugriffspunkt auf Rezeptzutaten in Datenbank
  ICRUDzutaten zutatenSchnittstelle = getIt<ICRUDzutaten>();

  ///Zugriffspunkt auf Zutatennamen in Datenbank
  ICRUDzutaten_Name zutatennameSchnittstelle = getIt<ICRUDzutaten_Name>();

  ///Zugriffspunkt auf schrittspezifische Zutaten in Datenbank
  ICRUDzutats_Menge schrittzutatenSchnittstelle = getIt<ICRUDzutats_Menge>();

  ///Zugriffspunkt auf Kategorien in Datenbank
  ICRUDkategorie kategorieSchnittstelle = getIt<ICRUDkategorie>();

  ///Zugriffspunkt auf Kategoriezuordnungen in Datenbank
  ICRUDkategorieRezeptZuordnung kategorieRezeptZuordnungSchnittstelle =
      getIt<ICRUDkategorieRezeptZuordnung>();

  ///Zugriffspunkt auf Einkaufslisteneinträge in Datenbank
  ICRUDeinkaufsliste einkaufslisteSchnittstelle = getIt<ICRUDeinkaufsliste>();

  ///Zugriffspunkt auf gekochte/geplante Rezepte in Datenbank
  ICRUDgekochtesRezept gekochtesRezeptSchnittstelle =
      getIt<ICRUDgekochtesRezept>();

  ///Zugriffspunkt auf Naehrwertangaben in der Datenbank
  ICRUDnaehrwerte_pro_100g naehrwertSchnittstelle =
      getIt<ICRUDnaehrwerte_pro_100g>();

  ///aktuelles Rezept
  Rezept rezept =
      Rezept(rezept_id: 0, titel: '', dauer: 0, anspruch: 0, bild: '');

  ///Schritte des aktuellen Rezepts
  List<Schritte_Rezeptanzeige> schrittliste = [];

  ///zu kochendes Rezept
  GekochtesRezept gekochtesRezept = GekochtesRezept(
      rezept_id: 0,
      gekochtesRezept_ID: 0,
      abgeschlossen: false,
      datum: DateTime(0000, 00, 00),
      naehrwert_id: 0,
      status: 0);

  bool inAusfuehrung = false;
  bool gesucht = false;
  String suchtitel = "";
  List<String> suchKategorien = [];
  List<String> suchAusschlussZutaten = [];

  ///Zutatennamen des aktuellen Rezepts
  List<String> zutatennamen = [];

  ///Zutaten des aktuellen Rezepts
  List<Zutat_Rezeptanzeige> zutatenliste = [];

  ///speichert Zutaten als Liste von Objekten mit Name, Menge, Einheit einer Zutat
  @override
  final einkaufslisteNotifier = ValueNotifier<List<Zutat_Rezeptanzeige>>(
      [Zutat_Rezeptanzeige(name: "", menge: "", einheit: "")]);


  ///speichert Naehrwerte des Rezepts in einem Nährwertobjekt
  @override
  final naehrwertNotifier = ValueNotifier<Naehrwerte>(
      Naehrwerte(kcal: 0, fat :0, saturatedFat: 0, sodium:  0, sugar: 0, protein: 0, ));

  ///Speichert vom Nutzer gewählte Portionsangabe, default 1
  double aktuelleportion = 1.0;

  ///Kategorien des aktuellen Rezepts
  List<String> kategorienliste = [];

  ///Lädt anhand der [rezeptid] alle Daten zu dem Rezept in den Controller.
  Future<void> RezeptHolen(int rezeptid) async {
    schrittliste = []; //Reihenfolge klären
    zutatenliste = [];
    kategorienliste = [];
    rezept = await rezeptSchnittstelle.getRezept(rezeptid);
    print(rezept.rezept_id);
    var schritte = await schrittSchnittstelle.getSchritteByRezeptId(rezeptid);
    var zutaten = await zutatenSchnittstelle.getRezeptZutaten(rezeptid);
    var kategoriezuordnungen = await kategorieRezeptZuordnungSchnittstelle
        .getKategorieRezeptZuordnungByRezeptID(rezeptid);

    for (int i = 0; i < kategoriezuordnungen.length; i++) {
      var kategorie = await kategorieSchnittstelle
          .getKategorie(kategoriezuordnungen.elementAt(i).kategorie_id);
      kategorienliste.add(kategorie.kategorie);
    }

    for (int i = 0; i < zutaten.length; i++) {
      Zutaten_Name name = await zutatennameSchnittstelle
          .getZutatenName(zutaten.elementAt(i).name_id);
      zutatenliste.add(Zutat_Rezeptanzeige(
          name: name.deutsch,
          menge: zutaten.elementAt(i).menge_pp.toDouble().toString(),
          einheit: "g")); // Hier noch Einheit einfügen
    }

    for (int i = 0; i < schritte.length; i++) {
      String zusatz = "";
      int zusatzwert = -1;
      bool wiege = false;
      if (schritte.elementAt(i).timer > 0) {
        zusatzwert = schritte.elementAt(i).timer;
        zusatz = "min";
      } else if (schritte.elementAt(i).waage) {
        wiege = true;

        var zutatsmenge = await schrittzutatenSchnittstelle
            .getZutatsMengenBySchrittid(schritte.elementAt(i).schritt_id);
        var korrespondierendeZutat =
            await zutatenSchnittstelle.getZutat(zutatsmenge.zutaten_id);
        var korrespondierenderName = await zutatennameSchnittstelle
            .getZutatenName(korrespondierendeZutat.name_id);

        zusatzwert = await (zutatsmenge.teilmenge);
        zusatz = zutatsmenge.einheit + " " + korrespondierenderName.deutsch;
      }
      schrittliste.add(Schritte_Rezeptanzeige(
          anweisung: schritte.elementAt(i).beschreibung,
          wiege: wiege,
          zusatz: zusatz,
          zusatzwert: zusatzwert,
          schrittid: schritte.elementAt(i).schrittnummer));
    }

    einkaufslisteNotifier.value = zutatenliste;

    naehrwerteBerechnen();
  }

  ///Übergibt die Daten des aktuellen Rezepts an die KochenSteuerung Komponente und führt Wechsel zu Kochentab herbei
  void kochen() {
    getIt<KochenRezeptAnzeigenController>().RezeptSetzen(rezept, schrittliste,
        0, zutatennamen, zutatenliste, aktuelleportion, kategorienliste);
    getIt<SettingsController>().onItemTapped(3);
  }

  /// Berechnet für die Zutatenliste und die Schrittliste die neuen Mengenangaben für [portion] Portionen und passt den Wert von aktuelleportion an
  void portionAnpassen(double portion) {
    print(aktuelleportion);
    print(portion);
    for (int i = 0; i < zutatenliste.length; i++) {
      zutatenliste[i].menge =
          ((double.parse(zutatenliste[i].menge) / aktuelleportion * portion))
              .toString();
    }
    for (int i = 0; i < schrittliste.length; i++) {
      if (schrittliste[i].wiege) {
        schrittliste[i].zusatzwert =
            (schrittliste[i].zusatzwert / aktuelleportion * portion).toInt();
      }
    }
    aktuelleportion = portion;

    naehrwerteBerechnen();
  }

  int rezeptidGeben() {
    return rezept.rezept_id;
  }

  ///Gibt die aktuelle vom Nutzer gewählte Portionsangabe zurück
  double portionGeben() {
    return aktuelleportion;
  }

  ///Gibt den Titel des aktuellen Rezepts aus
  String titelGeben() {
    return rezept.titel;
  }

  /// Setzt den Titel des aktuellen Rezepts auf [titel]
  void titelSetzen(String titel) {
    //Titel peristent speichern
  }

  ///Gibt den Dateipfad des Bildes des aktuellen Rezepts zurück
  String bildGeben() {
    return rezept.bild;
  }

  /// Setzt den Dateipfad des Bildes des aktuellen Rezepts auf [bild]
  void bildSetzen(String bild) {}

  ///Gibt die Dauer des aktuellen Rezepts aus
  int dauerGeben() {
    return rezept.dauer;
  }

  ///Setzt die Dauer des aktuellen Rezepts auf [dauer]
  void dauerSetzen(int dauer) {}

  ///Gibt eine Liste an 5 Farbwerten zurück, die dem Anspruch entsprechend oft gelb und sonst schwarz enthält
  List<Color> anspruchGeben() {
    List<Color> liste = ([
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black
    ]);
    for (int i = 0; i < rezept.anspruch; i++) {
      liste[i] = Colors.yellow;
    }
    return liste;
  }

  ///Gibt einen ganzzahligen Wert zwischen 0 und 4 aus, der den Anspruch der Rezepts darstellt
  int anspruchGebenInt() {
    return rezept.anspruch;
  }

  ///Setzt den Anspruch des aktuellen Rezepts auf [anspruch]
  void anspruchSetzen(int anspruch) {}

  ///Setzt die aktuelle Portion wieder auf 1 zurück
  void aktuellPortionZurueckSetzen() {
    this.aktuelleportion = 1.0;
  }

  ///Gibt eine Liste an Objekten zurück, die jeweils einen String für name, menge und einheit einer Zutat enthalten
  List<Zutat_Rezeptanzeige> zutatenGeben() {
    return zutatenliste;
  }

  ///Gibt eine Liste an Objekten zurück, die jeweils
  ///String anweisung
  ///   int schrittid
  ///   bool wiege
  ///   String zusatz
  ///   int zusatzwert
  ///   für jeden Schritt des aktuellen Rezepts enthalten
  List<Schritte_Rezeptanzeige> schritteGeben() {
    return schrittliste;
  }

  /// Gibt eine Liste an Strings mit den Kategorienamen des aktuellen Rezepts zurück
  List<String> kategorienGeben() {
    return kategorienliste;
  }

  ///Löscht das aktuelle Rezept und alle Daten die seine Rezeptid beinhalten aus der Datenbank
  Future<int> loeschen() async {
    await schrittSchnittstelle.deleteSchritteNachRezeptId(rezept.rezept_id);
    await schrittzutatenSchnittstelle
        .deleteZutatsMengeByRezeptId(rezept.rezept_id);
    await kategorieRezeptZuordnungSchnittstelle
        .deleteKategorieRezeptZuordnungNachRezeptId(rezept.rezept_id);
    await zutatenSchnittstelle.deleteZutatenNachRezeptId(rezept.rezept_id);
    await rezeptSchnittstelle.deleteRezept(rezept.rezept_id);
    return 0;
  }

  ///Erstellt mit dem Wunschdatum der Ausführung [datum] und den bereits geladenen Daten des Rezepts ein GekochtesRezept , übergibt dies an die PläneSteuerung Komponente und führt Wechsel zu Plänetab herbei
  void planen(DateTime datum) {
    //Muss noch programmiert werden
  }

  ///Gibt Liste an Zutaten die eingekauft werden sollen zurück, die jeweils einen String für name, menge und einheit einer Zutat enthalten
  ///- default: Liste der Rezeptzutaten
  List<Zutat_Rezeptanzeige> einkaufszutatenGeben() {
    return einkaufslisteNotifier.value;
  }

  ///Speichert [name], [menge], [einheit] als Zutatsobjekt in eine Liste und informiert Listener über Änderung der Liste
  void einkaufszutatHinzufuegen(String name, String menge, String einheit) {
    List<Zutat_Rezeptanzeige> neueListe = [];
    for (int i = 0; i < einkaufslisteNotifier.value.length; i++) {
      neueListe.add(einkaufslisteNotifier.value[i]);
    }
    neueListe
        .add(Zutat_Rezeptanzeige(name: name, menge: menge, einheit: einheit));

    einkaufslisteNotifier.value = neueListe;
  }

  ///Löscht Eintrag an der [index]-ten Stelle der Liste der Zutaten die eingekauft werden sollen
  ///Falls index außerhalb der Listenlänge liegt, passiert nichts
  void einkaufszutatLoeschen(int index) {
    List<Zutat_Rezeptanzeige> neueListe = [];
    for (int i = 0; i < einkaufslisteNotifier.value.length; i++) {
      if (i != index) {
        neueListe.add(einkaufslisteNotifier.value[i]);
      } else {}
    }

    einkaufslisteNotifier.value = neueListe;
  }

  ///Setzt die Einkaufsliste auf die ursprüngliche Zutatenliste des Rezepts zurück
  void resetZutatenliste() {
    einkaufslisteNotifier.value = zutatenliste;
  }

  ///Speichert die Liste der Zutaten, die eingekauft werden sollen in die Datenbank ein
  Future<void> einkaufsListeUebernehmen() async {
    for (int i = 0; i < einkaufslisteNotifier.value.length; i++) {
      int name_id = await zutatennameSchnittstelle.setZutatenName(
          einkaufslisteNotifier.value[i].name, "");
      await einkaufslisteSchnittstelle.setEinkaufsliste(
        name_id,
        rezept.rezept_id,
        (double.parse(einkaufslisteNotifier.value[i].menge)).toInt(),
        einkaufslisteNotifier.value[i].einheit,
      ); //Weiter füllen
    }
  }


  void SetzeInAusfuehrung(bool inAusfuehrung) {
    this.inAusfuehrung;
  }

  void SetzeGesucht(bool gesucht) {
    this.gesucht = gesucht;
  }

  void SetzeSuchtitel(String suchtitel) {
    this.suchtitel = suchtitel;
  }

  void SetzeSuchKategorien(List<String> suchKategorien) {
    this.suchKategorien = suchKategorien;
  }

  void SetzeSuchAusschlussZutaten(List<String> suchAusschlussZutaten) {
    this.suchAusschlussZutaten = suchAusschlussZutaten;
  }

  void SetzeDatumZurAusfuehrung(DateTime? pickedDate) {
    gekochtesRezept.datum = pickedDate;
  }

  DateTime? GibDatumZurAusfuehrung() {
    return gekochtesRezept.datum;
  }

  void gekochtesRezeptSpeichern() {
    //portion auch mit einspeichern!
  }

  Future<void> naehrwerteBerechnen() async {
    double kcal = 0;
    double fat = 0;
    double saturatedFat = 0;
    double sugar = 0;
    double protein = 0;
    double sodium = 0;

    for (int i = 0; i < zutatenliste.length; i++) {
      int zutatennameid =
          await zutatennameSchnittstelle.getZutatenNameId(zutatenliste[i].name);
      var naehrwerte =
          await naehrwertSchnittstelle.getNaehrwertByNameId(zutatennameid);
      if (naehrwerte != null) {
        if (naehrwerte.kcal != -1 && kcal != -1) {
          kcal = kcal + naehrwerte.kcal/100*double.parse(zutatenliste[i].menge);
        } else {
          kcal = -1;
        }
        if (naehrwerte.fett != -1 && fat != -1) {
          fat = fat + naehrwerte.fett/100*double.parse(zutatenliste[i].menge);
        } else {
          fat = -1;
        }
        if (naehrwerte.gesaettigteFettsaeuren != -1 && saturatedFat != -1) {
          saturatedFat = saturatedFat + naehrwerte.gesaettigteFettsaeuren/100*double.parse(zutatenliste[i].menge);
        } else {
          saturatedFat = -1;
        }


        if (naehrwerte.zucker != -1 && sugar != -1) {
          sugar = sugar + naehrwerte.zucker/100*double.parse(zutatenliste[i].menge);
        } else {
          sugar = -1;
        }

        if (naehrwerte.eiweiss != -1 && protein != -1) {
          protein = protein + naehrwerte.eiweiss/100*double.parse(zutatenliste[i].menge);
        } else {
          protein = -1;
        }
        if (naehrwerte.salz != -1 && sodium != -1) {
          sodium = sodium + naehrwerte.salz/100*double.parse(zutatenliste[i].menge);
        } else {
          sodium = -1;
        }
      }
    }


    naehrwertNotifier.value= Naehrwerte(kcal: kcal, fat :fat, saturatedFat: saturatedFat, sodium:  sodium, sugar: sugar, protein: protein, );

    //Muss noch auf Menge angepasst werden

  }
}
