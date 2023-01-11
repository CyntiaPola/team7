

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorie.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDschritt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutats_Menge.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat_Rezeptanzeige.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';
import '../../Datenhaltung/DatenhaltungsAPI/ICRUDkategorieRezeptZuordnung.dart';
import '../../Datenhaltung/DatenhaltungsAPI/rezept.dart';
import '../../Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';
import '../SteuerungsAPI/Schritte_Rezeptanzeige.dart';

class KochenRezeptAnzeigenControllerImpl implements KochenRezeptAnzeigenController{

  ///Zugriffspunkt auf die RezepteGUI in der Datenbank
  ICRUDRezept rezeptSchnittstelle = getIt<ICRUDRezept>();
  ///Zugriffspunkt auf die Schritte in der Datenbank
  ICRUDschritt schrittSchnittstelle = getIt<ICRUDschritt>();
  ///Zugriffspunkt auf die RezepteGUI in der Datenbank
  ICRUDzutaten zutatenSchnittstelle = getIt<ICRUDzutaten>();
  ///Zugriffspunkt auf die Zutatennamen in der Datenbank
  ICRUDzutaten_Name zutatennameSchnittstelle= getIt<ICRUDzutaten_Name>();
  ///Zugriffspunkt auf die Schrittzutaten in der Datenbank
  ICRUDzutats_Menge schrittzutatenSchnittstelle= getIt<ICRUDzutats_Menge>();
  ///Zugriffspunkt auf die Kategorien in der Datenbank
  ICRUDkategorie kategorieSchnittstelle = getIt<ICRUDkategorie>();
  ///Zugrifsspunkt auf die KategorieRezeptzuordnungen in der Datebank
  ICRUDkategorieRezeptZuordnung kategorieRezeptZuordnungSchnittstelle = getIt<ICRUDkategorieRezeptZuordnung>();

  ///Speichert für das aktuelle Rezept den aktuell als nächstes anzuzeigenden Schritt
  ///-default -1 zeigt Bildschirm mit Rezeptsuchbutton
  final schrittnotifier= ValueNotifier<int>(-1);

  ///Speichert ktuell zu kochendes/anzuzeigendes Rezept
  Rezept rezept= Rezept(rezept_id: 0, titel: '', dauer: 0, anspruch: 0, bild: '');


  ///Speichert die Schritte des aktuellen Rezepts mit
  ///  String anweisung;
  ///   int schrittid;
  ///   bool wiege;
  ///   String zusatz;
  ///   int zusatzwert;
  ///   für jeden Schritt
  List<Schritte_Rezeptanzeige> schrittliste=[];


  ///Speichert die Zutatennamen des aktuellen Rezepts
  List<String> zutatennamen=[];

  ///Speichert die Zutaten des aktuellen Rezepts
  List<Zutat_Rezeptanzeige> zutatenliste=[];


  ///Speichert die gewählte Portionsangabe des gewählten Rezepts
  double aktuelleportion=1.0;
  List<String> kategorienliste=[];




  ///Setzt die Daten des aktuellen Rezepts auf die übergebenen Werte
  ///Diese Methode wird von Steuerungsklassen aufgerufen, wenn in ihrer zugehörigen GUI der Kochenbutton geklickt wird und die Komponente selbst noch kein
  ///GekochtesRezept angelegt hat
  ///So erhält die KochenSteuerung die Daten zum gewünschten Rezept
  void RezeptSetzen(Rezept rezept, List<Schritte_Rezeptanzeige> schrittliste, int schrittzaehler,  List<String> zutatennamen , List<Zutat_Rezeptanzeige> zutatenliste, double aktuelleportion, List<String> kategorienliste ){
  this.rezept=rezept;
   this.schrittliste=schrittliste;
   schrittnotifier.value=schrittzaehler;
   this.zutatennamen=zutatennamen;
   this.zutatenliste=zutatenliste;
   this.aktuelleportion=aktuelleportion;
   this.kategorienliste=kategorienliste;

  }




  ///Gibt die gewählte Portion des aktuellen Rezepts zurück
  double portionGeben(){
    return aktuelleportion;
  }


  void portionSetzen(double aktuellePortion){
    this.aktuelleportion=aktuellePortion;
  }

  ///Gibt den Titel des aktuellen Rezepts zurück
  String titelGeben(){
    return rezept.titel;
  }

  ///Gibt den Pfad des Bildes dea aktuellen Rezepts zurück
  String bildGeben(){
    return rezept.bild;
  }

  ///Gibt die Dauer des aktuellen Rezepts zurück
  int dauerGeben(){
    return rezept.dauer;
  }


  ///Gibt den Anspruch des aktuellen Rezepts als Farbarray mit 5 Werten zurück
  ///entsprechend des Anspruchs oft kommt gelb vor, dann schwarz
  List<Color> anspruchGeben(){
   List<Color> liste = ([Colors.black,Colors.black,Colors.black,Colors.black,Colors.black]);
    for(int i=0; i<rezept.anspruch; i++){
      liste[i]=Colors.yellow;
    }
    return liste;
  }

  ///Gibt den Anspruch-1 als Ganzzahl im Bereich 0-4 zurück
  int anspruchGebenInt(){
    return rezept.anspruch;
  }

  ///Setzt die aktuell gewählte Portion auf 1 zurück
  void aktuellPortionZurueckSetzen(){
    this.aktuelleportion=1.0;
  }

///gibt eine Liste der Zutaten des aktuellen Rezepts mit
  ///String name
  ///String menge
  ///String einheit
  ///der jeweiligen Zutat zurück
  List<Zutat_Rezeptanzeige> zutatenGeben(){
    return zutatenliste;
  }


  ///Gibt eine Liste von Schritten des aktuellen Rezepts mit
  ///String schritt;
  ///   String zutat;
  ///   String menge;
  ///   String einheit;
  ///   String zeit;
  ///   bool wiegeschritt; sagt, ob Schritt Wiegeschritt ist und deshalb zutat, menge, einheit beachtet werden soll
  ///   bool timerschritt; sagt, ob Schritt Timerschritt ist und deshalb zeit beachtet werden soll
  ///   zurück
 List<Schritte_Rezeptanzeige> schritteGeben()  {

    return schrittliste;
  }


  ///Gibt eine Liste an Kategorien des aktuellen Rezepts zurück
  List<String> kategorienGeben(){
    return kategorienliste;
  }



  ///Gibt zum aktuellen Rezept und dem aktuellen Wert vom Schrittindikator schrittnotifier den
  ///aktuellen Schritt mit
  ///String schritt;
    ///   String zutat;
     ///   String menge;
    ///   String einheit;
     ///   String zeit;
     ///   bool wiegeschritt; sagt, ob Schritt Wiegeschritt ist und deshalb zutat, menge, einheit beachtet werden soll
    ///   bool timerschritt; sagt, ob Schritt Timerschritt ist und deshalb zeit beachtet werden soll
     ///   zurück
  Schritte_Rezeptanzeige aktuellerSchrittGeben(){

    return schrittliste[schrittnotifier.value%schrittliste.length];
  }


///Setzt den aktuellen Schrittzaehler auf den Wert [schrittnummer]
  void aktuellerSchrittSetzen(int schrittnummer){

    schrittnotifier.value = schrittnummer;

  }

  ///Lädt anhand der [rezeptid] alle Daten zu dem Rezept in den Controller.
  Future<void> RezeptHolen(int rezeptid) async {

    schrittliste=[];  //Reihenfolge klären
    zutatenliste=[];
    kategorienliste=[];
    rezept= await rezeptSchnittstelle.getRezept(rezeptid);
    print(rezept.rezept_id);
    var schritte= await schrittSchnittstelle.getSchritteByRezeptId(rezeptid);
    var zutaten = await zutatenSchnittstelle.getRezeptZutaten(rezeptid);
    var kategoriezuordnungen = await kategorieRezeptZuordnungSchnittstelle.getKategorieRezeptZuordnungByRezeptID(rezeptid);

    for(int i=0; i< kategoriezuordnungen.length; i++){
      var kategorie= await kategorieSchnittstelle.getKategorie(kategoriezuordnungen.elementAt(i).kategorie_id);
      kategorienliste.add(kategorie.kategorie);
    }

    for(int i=0; i< zutaten.length; i++){

      Zutaten_Name name = await zutatennameSchnittstelle.getZutatenName(zutaten.elementAt(i).name_id);
      zutatenliste.add(Zutat_Rezeptanzeige(name: name.deutsch, menge: zutaten.elementAt(i).menge_pp.toDouble().toString(), einheit: "g")); // Hier noch Einheit einfügen
    }

    for(int i=0; i< schritte.length; i++){
      String zusatz="";
      int zusatzwert=-1;
      bool wiege =false;
      if(schritte.elementAt(i).timer>0){
        zusatzwert=schritte.elementAt(i).timer;
        zusatz= "min";
      }
      else if( schritte.elementAt(i).waage){
        wiege=true;

        var zutatsmenge = await schrittzutatenSchnittstelle.getZutatsMengenBySchrittid(schritte.elementAt(i).schritt_id);
        var korrespondierendeZutat = await zutatenSchnittstelle.getZutat(zutatsmenge.zutaten_id);
        var korrespondierenderName= await zutatennameSchnittstelle.getZutatenName(korrespondierendeZutat.name_id);

        zusatzwert= await (zutatsmenge.teilmenge);
        zusatz=   zutatsmenge.einheit+" "+korrespondierenderName.deutsch;
      }
      schrittliste.add(Schritte_Rezeptanzeige(anweisung: schritte.elementAt(i).beschreibung, wiege: wiege, zusatz: zusatz, zusatzwert: zusatzwert,  schrittid: schritte.elementAt(i).schrittnummer));
    }
  }











}