

import 'GekochtesRezeptGrenzklasse.dart';
import 'Naehrwerte.dart';

abstract class Kochen_Controller{

  get timer;

  get count1Notifier;
  get count2Notifier;
  get startNotifier;
  get counternoteditableNotifier;
  get schrittschonmalgestartet;
  get naehrwerte;
  get dichteNotifier;

  ///Leitet den Tabwechsel vom KochenTab auf den SuchenTab ein
  suchen();

  void gekochtesRezeptSetzen(GekochtesRezeptGrenzklasse gekochtesRezept);

  Future<int> gekochtesRezeptAnlegenBeiKlickAufKochen(int rezeptid , double portion  );

  Future<void> gekochtesRezeptAktualisieren(double menge, String zutat, bool abgeschlossen) ;

  Future<void> gibBerechneteNaehrwerte();

  ///Gibt true zurück, wenn ein unabgeschlossenes, letztes Rezept vorliegt
  Future<bool> unabgeschlossenesRezeptVorhanden();

  ///Lädt letztes Rezept in den KochenRezeptAnzeigenController und legt gekochtesRezept an, falls diese noch nicht abgeschlossen ist
  Future<void> moeglichesLetztesRezeptLaden();

  ///Löscht letztes unabgeschlossenes Rezept und setzt die Id des letzten Rezepts in den Settings auf -1
  Future <void> letztesRezeptLoeschen();

  Future<double> DichteLaden();

  Future<void> vorratskammerAnpassen(String name, int menge, String einheit);


  ///Lädt gekochtesRezept und die dort gespeicherte Portion in den KochenRezeptAnzeigenController
  ///und legt gekochtesRezept als Grenzklasse an, falls diese noch nicht abgeschlossen ist
  Future<void> unabgeschlossenesRezeptLaden(int letztesRezeptId);



}