import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/rezept.dart';

abstract class ICRUDRezept {
  ///Gibt alle Rezepte in der Datenbank zurück
  Future<Iterable> getRezepte();

  ///Gibt Rezept in der Datenbank mit der id [id] aus
  Future<Rezept> getRezept(int id);

  ///Gibt eine Liste an Rezepten zurück, die [titel] im Titel tragen
  Future<Iterable> getRezeptTitel(String titel);

  ///Speichert ein neues Rezept mit den Attributen [titel], [dauer], [anspruch], [bild]
  ///in die Datenbank ein
  Future<int> setRezept(String titel, int dauer, int anspruch, String bild);

  ///Löscht das Rezept mit der id [id]
  Future<int> deleteRezept(int id);

  ///Ändert das Rezept
  Future<void> updateRezept(
    int rezept_id,
    String titel,
    int dauer,
    int anspruch,
    String bild,
  );
}
