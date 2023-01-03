

import 'kategorie.dart';

///Klasse zur Verwaltung der Kategorien in der Datenbank
///Liefert keine DeleteMethode, da Kategorien durch die App nicht gelöscht werden können
abstract class ICRUDkategorie {


  ///Liefert alle Kategorien aus der Datenbank
  Future<Iterable> getKategorien();

  ///Liefert  Kategorie mit entsprechender [kategorie_id] aus der Datenbank
  Future<Kategorie> getKategorie(int kategorie_id);

  ///Legt Kategorie mit dem Namen [kategorie] in Datenbank an
  ///und gibt deren id zurück
  ///ist eine Kategorie dieses Namens schon in der Datenbank vorhanden, so
  ///wird kein neues Objekt erzeugt, sondern die id des alten zurückggeben
  Future<int> setKategorie(String kategorie);

  ///Liefert id der Kategorie mit dem Namen [kategorie]
  ///gibt es diese nicht, so wird -1 zurückggeben
  Future<int>  getKategorieIdByName(String kategorie);
}
