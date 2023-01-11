import 'dart:ui';

import 'package:smart_waage/Fachlogik/SteuerungsAPI/Schritte_Rezeptanzeige.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat_Rezeptanzeige.dart';

abstract class PlaeneRezeptAnzeigenController{

  ///Lädt anhand der [rezeptid] alle Daten zu dem Rezept in den Controller.
  Future<void> RezeptHolen(int rezeptid);

  ///Gibt den Titel des aktuellen Rezepts aus
  String titelGeben();


  ///Gibt den Dateipfad des Bildes des aktuellen Rezepts zurück
  String bildGeben();

  ///Gibt die Dauer des aktuellen Rezepts aus
  int dauerGeben();

  ///Gibt eine Liste an 5 Farbwerten zurück, die dem Anspruch entsprechend oft gelb und sonst schwarz enthält
  List<Color> anspruchGeben();

  ///Gibt einen ganzzahligen Wert zwischen 0 und 4 aus, der den Anspruch der Rezepts darstellt
  int anspruchGebenInt();

  /// Berechnet für die Zutatenliste und die Schrittliste die neuen Mengenangaben für [portion] Portionen und passt den Wert von aktuelleportion an
  void portionAnpassen(double portion);

  ///Setzt die aktuelle Portion wieder auf 1 zurück
  void aktuellPortionZurueckSetzen();

  /// Gibt eine Liste an Strings mit den Kategorienamen des aktuellen Rezepts zurück
  List<String> kategorienGeben();

  ///Gibt die aktuelle vom Nutzer gewählte Portionsangabe zurück
  double portionGeben();

  ///Übergibt die Daten des aktuellen Rezepts und des dazugehörigen GekochtesRezept an die KochenSteuerung Komponente und führt Wechsel zu Kochentab herbei
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


  Future<int> loeschen();

  get naehrwertNotifier;
  get naehrwerteAnzeigen;
  get gekochtesRezept;


}