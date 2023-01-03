
import 'schritt.dart';

abstract class ICRUDschritt {

  ///Liefert alle Schritt aus der Datenbank
  Future<Iterable> getSchritte();


  ///Liefert den [schrittnummer]-ten Schritt des Rezepts mit der id [rezept_id]
  Future<Schritt> getSchritt(int rezept_id, int schrittnummer);

  ///Speichert einen neuen Schritt mit den übergebenen Attributen in die Datenbank ein
  Future<int> setSchritt(int schrittnummer, int rezept_id, int timer,
      bool waage, String beschreibung);

  ///Liefert alle Schritte des Rezepts mit der id [rezept_id]
  Future<Iterable> getSchritteByRezeptId(int rezept_id);

  ///Löscht alle Schritte des Rezepts mit der id [rezept_id]
  Future<int> deleteSchritteNachRezeptId(int rezept_id);
}
