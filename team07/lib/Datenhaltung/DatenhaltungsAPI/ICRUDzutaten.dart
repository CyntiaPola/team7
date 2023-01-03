

import 'zutaten.dart';

abstract class ICRUDzutaten {


  ///Liefert alle Zutaten aus der Datenbank
  Future<Iterable> getAllZutaten();

  ///Liefert alle Zutaten zum Rezept mit der id [rezept_id]
  Future<Iterable> getRezeptZutaten(int rezeptid);

  ///Liefert die erste gefundene id der Zutat, die zum Rezept mit [rezeptid] gehört
  ///und den Namen [zutatsname_id] hat
  Future<int>  getRezeptZutatenByName(int rezeptid, int zutatsname_id);

  ///Liefert die Zutat mit der id [zutaten_id]
  Future<Zutaten> getZutat(int zutaten_id);

  ///Löscht alle Zutaten mit des Rezepts mit der id [rezept_id]
  Future<void> deleteZutatenNachRezeptId(int rezept_id);
  Future<int> setZutat(
      int name_id,
      int rezept_id,
      int naehrwert_id,
      int menge_pp,
      String einheit,
      int volumen_id,
      int masse_id,
      int dichte_id,
      bool skalierbar);
}
