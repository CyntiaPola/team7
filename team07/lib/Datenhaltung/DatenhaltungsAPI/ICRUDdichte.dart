import 'dichte.dart';

abstract class ICRUDdichte {
  ///Gibt alle gespeicherten Dichten aus der Datenbank zurück
  Future<Iterable> getDichten();

  ///Gibt die Dichte in der Datenbank mit der id [zutatsname_id] aus
  Future<Dichte?> getDichte(int zutatsname_id);

  ///Löscht die Dichte mit der id [dichte_id]
  Future<int> deleteDichte(int dichte_id);

  ///Speichert eine neue Dichte mit den Attributen [zutatsname_id], [volumen_pro_100g]
  ///in die Datenbank und gibt die [dichte_id] zurück
  Future<int> setDichte(int zutatsname_id, double volumen_pro_100g);

  ///Ändert die Dichte
  Future<void> updateDichte(
    int dichte_id,
    int zutatsname_id,
    double volumen_pro_100g,
  );
}
