
import 'kategorieRezeptZuordnung.dart';

abstract class ICRUDkategorieRezeptZuordnung {

  ///Liefert eine Liste aller KategorieRezeptZuordnungen aus der Datenbank
  Future<Iterable> getKategorieRezeptZuordnungen();


  ///Legt ein neue KategorieRezeptZuordnung in der Datenbank an mit der
  ///rezeptid[rezept_id] und der kategorie_id [kategorie_id]
  Future<int> setKategorieRezeptZuordnung(int kategorie_id, int rezept_id);

  ///Liefert eine Liste der von Kategoriezuordnungen zu dem Rezept mit der id [rezeptid]
  Future<Iterable> getKategorieRezeptZuordnungByRezeptID(int rezeptid);

  ///Löscht alle Zuordnungen, die die Rezeptid [rezept_id] beinhalten
  Future<int> deleteKategorieRezeptZuordnungNachRezeptId(int rezept_id);
}
