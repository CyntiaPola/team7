
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/GekochtesRezept.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat_Rezeptanzeige.dart';
import '../../Datenhaltung/DatenhaltungsAPI/rezept.dart';
import '../SteuerungsAPI/Schritte_Rezeptanzeige.dart';

abstract class KochenRezeptAnzeigenController{

  ///Gibt den Titel des aktuellen Rezepts zurück
  String titelGeben();

  ///Gibt den Pfad des Bildes dea aktuellen Rezepts zurück
  String bildGeben();

  ///Gibt die Dauer des aktuellen Rezepts zurück
  int dauerGeben();

  ///Gibt den Anspruch des aktuellen Rezepts als Farbarray mit 5 Werten zurück
  ///entsprechend des Anspruchs oft kommt gelb vor, dann schwarz
  List<Color> anspruchGeben();


  ///Gibt den Anspruch-1 als Ganzzahl im Bereich 0-4 zurück
  int anspruchGebenInt();

  ///Setzt die aktuell gewählte Portion auf 1 zurück
  void aktuellPortionZurueckSetzen();

  ///Gibt eine Liste an Kategorien des aktuellen Rezepts zurück
  List<String> kategorienGeben();

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
  Schritte_Rezeptanzeige aktuellerSchrittGeben();

  ///Setzt den aktuellen Schrittzaehler auf den Wert [schrittnummer]
  void aktuellerSchrittSetzen(int schrittnummer);

  ///Gibt die gewählte Portion des aktuellen Rezepts zurück
  double portionGeben();


  ///Speichert für das aktuelle Rezept den aktuell als nächstes anzuzeigenden Schritt
  ///-default -1 zeigt Bildschirm mit Rezeptsuchbutton
  get schrittnotifier;

  ///Setzt die Daten des aktuellen Rezepts auf die übergebenen Werte
  ///Diese Methode wird von Steuerungsklassen aufgerufen, wenn in ihrer zugehörigen GUI der Kochenbutton geklickt wird und die Komponente selbst noch kein
  ///GekochtesRezept angelegt hat
  ///So erhält die KochenSteuerung die Daten zum gewünschten Rezept
  void RezeptSetzen(Rezept rezept, List<Schritte_Rezeptanzeige> schrittliste, int schrittzaehler,  List<String> zutatennamen , List<Zutat_Rezeptanzeige> zutatenliste, double aktuelleportion, List<String> kategorienliste );


  ///Lädt anhand der [rezeptid] alle Daten zu dem Rezept in den Controller.
  Future<void> RezeptHolen(int rezeptid);

  ///Setzt die Daten des aktuellen Rezepts auf die übergebenen Werte
  ///Übernimmt zusätzlich noch ein bereits vorhandenes GekochtesRezept, wie es beim Wechsel von PLäneGUI auf Kochen bereits vorliegt
  ///Diese Methode wird von Steuerungsklassen aufgerufen, wenn in ihrer zugehörigen GUI der Kochenbutton geklickt wird
  ///So erhält die KochenSteuerung die Daten zum gewünschten Rezept
  void RezeptSetzenMitGekochtesRezept(Rezept rezept, List<Schritte_Rezeptanzeige> schrittliste, int schrittzaehler,  List<String> zutatennamen , List<Zutat_Rezeptanzeige> zutatenliste, double aktuelleportion, List<String> kategorienliste , GekochtesRezept gekochtesRezept);


  ///gibt eine Liste der Zutaten des aktuellen Rezepts mit
  ///String name
  ///String menge
  ///String einheit
  ///der jeweiligen Zutat zurück
  List<Zutat_Rezeptanzeige> zutatenGeben();

  ///Gibt eine Liste von Schritten des aktuellen Rezepts mit
  ///String schritt;
  ///   String zutat;
  ///   String menge;
  ///   String einheit;
  ///   String zeit;
  ///   bool wiegeschritt; sagt, ob Schritt Wiegeschritt ist und deshalb zutat, menge, einheit beachtet werden soll
  ///   bool timerschritt; sagt, ob Schritt Timerschritt ist und deshalb zeit beachtet werden soll
  ///   zurück
  List<Schritte_Rezeptanzeige> schritteGeben();


  ///Setzt das aktuell GekochteRezept auf [gekochtesRezept]
  void GekochtesRezeptSetzen(GekochtesRezept gekochtesRezept);

}