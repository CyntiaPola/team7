
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutats_Menge.dart';

abstract class ICRUDzutats_Menge {

  ///Legt eine neue Zutatenmenge mit den übergebenen Attributen in der Datenbank an
  setZutatsMenge(int rezept_id, int schritt_id, int zutaten_id,
      int teilmenge, String einheit);

  ///Liefert die Zutats_Menge zum Schritt mit der id [schrittid]
  Future<Zutats_Menge> getZutatsMengenBySchrittid(int schrittid);

  ///Löscht alle Zutatsmenge die zum Rezept mit der id [rezept_id] gehören
  Future<void> deleteZutatsMengeByRezeptId(int rezept_id);
}
