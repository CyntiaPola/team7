import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/settings.dart';

abstract class ICRUDsettings {
  ///Speichert die Settings mit den übergebenen Attributen in die Datenbank
  Future<int> setSettings(int toleranzbereich, bool vorratskammerNutzen,
      int letztesRezept_id, bool NaehrwerteAnzeigen);

  ///Liefert die Settings aus der Datenbank
  Future<Settings> getSettings();

  ///Löscht die Settings aus der Datenbank
  Future<int> deleteSettings(int settingsID);
}
