

import 'GekochtesRezeptGrenzklasse.dart';

abstract class WochenplanController{

  ///Lädt alle geplanten und schon gekochten Rezepte aus der Datenbank
  Future<void> gibWochenplan();

  ///Speichert Liste aller geplanten und schon gekochten Rezepte der Klasse und kann Listener über Änderungen benachrichtigen
  get WochenplanNotifier;


  ///Leitet den Tabwechsel vom PläneTab auf den SuchenTab ein
  suchen() ;

}