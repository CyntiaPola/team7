import 'package:smart_waage/Fachlogik/SteuerungsAPI/GekochtesRezept.dart';

abstract class WochenplanController{

  ///Lädt alle geplanten und schon gekochten Rezepte aus der Datenbank
  Future<void> gibWochenplan();

  ///Speichert Liste aller geplanten und schon gekochten Rezepte der Klasse und kann Listener über Änderungen benachrichtigen
  get WochenplanNotifier;


  ///Leitet den Tabwechsel zum Rezepte Tab ein
  RezeptSuchen();


  /// Speichert [gekochtesRezept] in [WochenplanNotifier] ein und benachrichtigt so Listener über Änderungen
  RezeptInWochenplanEinfuegen(GekochtesRezept gekochtesRezept);

}