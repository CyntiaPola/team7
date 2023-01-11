import 'einkaufsliste.dart';

abstract class ICRUDeinkaufsliste {
  ///Gibt alle Einkaufslisten in der Datenbank zurueck
  Future<Iterable> getEinkaufslisten();

  ///Gibt die Einkaufsliste in der Datenbank mit der id [einkaufsliste_id] aus
  Future<Einkaufsliste> getEinkaufsliste(int einkaufsliste_id);

  ///Löscht die Einkaufsliste mit der id [einkaufsliste_id]
  Future<int> deleteEinkaufsliste(int einkaufsliste_id);

  ///Speichert eine neue Einkaufsliste mit den Attributen [zutatsname_id], [rezept_id], [menge],
  /// [einheit] in die Datenbank und gibt [einkaufsliste_id] zurueck
  Future<int> setEinkaufsliste(
      int zutatsname_id, int rezept_id, int menge, String einheit);

  ///Aendert die Einkaufsliste
  Future<void> updateEinkaufsliste(
    int einkaufsliste_id,
    int zutatsname_id,
    int rezept_id,
    int menge,
    String einheit,
  );
}
