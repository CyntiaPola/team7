import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/vorratskammerinhalt.dart';

abstract class ICRUDvorratskammerinhalt {
  ///Gibt Vorratskammerinhalt in der Datenbank mit der id [vorratskammerinhalt_id] aus
  Future<Vorratskammerinhalt> getVorratskammerinhalt(
      int vorratskammerinhalt_id);

  ///Gibt alle Vorratskammerinhalte in der Datenbank zurueck
  Future<Iterable?> getVorratskammerinhalte();

  ///Speichert einen neuen Vorratskammerinhalt mit den Attributen [zutatsname_id], [menge], [einheit],
  ///in die Datenbank und gibt [vorratskammerinhalt_id] zurueck
  Future<int> setVorratskammerinhalt(
    int zutatsname_id,
    int menge,
    String einheit,
  );

  ///Loescht den Vorratskammerinhalt mit der id [vorratskammerinhalt_id]
  Future<int> deleteVorratskammerinhalt(int vorratskammerinhalt_id);

  ///Aendert den Vorratskammerinhalt
  Future<void> updateVorratskammerinhalt(
    int vorratskammerinhalt_id,
    int zutatsname_id,
    int menge,
    String einheit,
  );
}
