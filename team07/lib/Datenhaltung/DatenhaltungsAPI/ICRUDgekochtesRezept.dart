import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/gekochtesRezept.dart';

abstract class ICRUDgekochtesRezept {
  ///Gibt alle gekochtesRezept in der Datenbank zurück
  Future<Iterable> getGekochteRezepte();

  ///Gibt gekochtesRezept in der Datenbank mit der id [gekochtesRezept_ID] aus
  Future<GekochtesRezept?> getgekochtesRezept(int gekochtesRezept_ID);

  ///Speichert ein neues GekochteRezept mit den Attributen [rezept_id], [datum], [abgeschlossen],
  /// [naehrwert_id], [status], [portion]
  ///in die Datenbank ein
  Future<int> setGekochteRezept(
    int rezept_id,
    var datum,
    bool abgeschlossen,
    int naehrwert_id,
    int status,
    double portion,
  );

  ///Löscht das GekochtesRezept mit der id [gekochtesRezept_ID]
  Future<int> deleteGekochtesRezept(int gekochtesRezept_ID);

  ///Ändert das GekochteRezept
  Future<void> updateGekochtesRezept(
    int gekochtesRezept_ID,
    int rezept_id,
    var datum,
    bool abgeschlossen,
    int naehrwert_id,
    int status,
    double portion,
  );
}
