
import 'package:flutter/material.dart';

import 'Naehrwerte.dart';
import 'Schritte_Rezeptanzeige.dart';
import 'Zutat_Rezeptanzeige.dart';

abstract class RezeptAnzeigenController{

  ///Lädt anhand der [rezeptid] alle Daten zu dem Rezept in den Controller.
  Future<void> RezeptHolen(int rezeptid);

  ///Gibt den Titel des aktuellen Rezepts aus
  String titelGeben();

  /// Setzt den Titel des aktuellen Rezepts auf [titel]
  void titelSetzen(String titel);

  ///Gibt den Dateipfad des Bildes des aktuellen Rezepts zurück
  String bildGeben();

  /// Setzt den Dateipfad des Bildes des aktuellen Rezepts auf [bild]
  void bildSetzen( String bild);

  ///Gibt die Dauer des aktuellen Rezepts aus
  int dauerGeben();

  ///Setzt die Dauer des aktuellen Rezepts auf [dauer]
  void dauerSetzen( int dauer);

  ///Gibt eine Liste an 5 Farbwerten zurück, die dem Anspruch entsprechend oft gelb und sonst schwarz enthält
  List<Color> anspruchGeben();

  ///Gibt einen ganzzahligen Wert zwischen 0 und 4 aus, der den Anspruch der Rezepts darstellt
  int anspruchGebenInt();

  ///Setzt den Anspruch des aktuellen Rezepts auf den Wert [anspruch]
  void anspruchSetzen( int anspruch);

  /// Berechnet für die Zutatenliste und die Schrittliste die neuen Mengenangaben für [portion] Portionen und passt den Wert von aktuelleportion an
  void portionAnpassen(double portion);

  ///Setzt die aktuelle Portion wieder auf 1 zurück
  void aktuellPortionZurueckSetzen();

  /// Gibt eine Liste an Strings mit den Kategorienamen des aktuellen Rezepts zurück
  List<String> kategorienGeben();

  ///Gibt die aktuelle vom Nutzer gewählte Portionsangabe zurück
  double portionGeben();

  ///Löscht das aktuelle Rezept und alle Daten die seine Rezeptid beinhalten aus der Datenbank
  Future<int> loeschen();

  ///Übergibt die Daten des aktuellen Rezepts an die KochenSteuerung Komponente und führt Wechsel zu Kochentab herbei
  void kochen();


  ///Gibt eine Liste der Zutaten des aktuellen Rezepts zurück, die jeweils einen String für name, menge und einheit einer Zutat enthalten
  List<Zutat_Rezeptanzeige> zutatenGeben();

  ///Gibt eine Liste an Objekten zurück, die jeweils
  ///String anweisung
  ///   int schrittid
  ///   bool wiege
  ///   String zusatz
  ///   int zusatzwert
  ///   für jeden Schritt des aktuellen Rezepts enthalten
  List<Schritte_Rezeptanzeige> schritteGeben();







  ///Erstellt mit dem Wunschdatum der Ausführung [datum] und den bereits geladenen Daten des Rezepts ein GekochtesRezept , übergibt dies an die PläneSteuerung Komponente und führt Wechsel zu Plänetab herbei
  void planen(DateTime datum);




  ///Gibt Liste an Zutaten die eingekauft werden sollen zurück, die jeweils einen String für name, menge und einheit einer Zutat enthalten
  ///- default: Liste der Rezeptzutaten
  List<Zutat_Rezeptanzeige> einkaufszutatenGeben();


  ///Speichert [name], [menge], [einheit] als Zutatsobjekt in eine Liste und informiert Listener über Änderung der Liste
  void einkaufszutatHinzufuegen(String name, String menge, String einheit);

  ///Löscht Eintrag an der [index]-ten Stelle der Liste der Zutaten die eingekauft werden sollen
  ///Falls index außerhalb der Listenlänge liegt, passiert nichts
  void einkaufszutatLoeschen(int index);


  ///Setzt die Einkaufsliste auf die ursprüngliche Zutatenliste des Rezepts zurück
  void resetZutatenliste();


  ///Speichert die Liste der Zutaten, die eingekauft werden sollen in die Datenbank ein
  Future<void> einkaufsListeUebernehmen();



  ///Gibt die Rezeptid des angezeigten Rezepts zurück
  int rezeptidGeben();

  get inAusfuehrung;
  get gesucht;
  get suchtitel;
  get suchKategorien;
  get suchAusschlussZutaten;
  get einkaufslisteNotifier;
  get naehrwertNotifier;

  void SetzeInAusfuehrung(bool inAusfuehrung);
  void SetzeGesucht(bool gesucht);
  void SetzeSuchtitel(String suchtitel);
  void SetzeSuchKategorien(List<String> suchKategorien);
  void SetzeSuchAusschlussZutaten(List<String> suchAusschlussZutaten);
  void SetzeDatumZurAusfuehrung(DateTime? pickedDate);
  DateTime? GibDatumZurAusfuehrung();
  void gekochtesRezeptSpeichern();
  Future<void> naehrwerteBerechnen();






}

