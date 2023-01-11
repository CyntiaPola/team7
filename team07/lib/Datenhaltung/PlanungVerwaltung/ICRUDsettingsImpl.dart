import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDsettings.dart';

import '../DatenhaltungsAPI/settings.dart';

class ICRUDsettingsImpl implements ICRUDsettings {
  //Singelton pattern
  static final ICRUDsettingsImpl _instance = ICRUDsettingsImpl._internal();
  ICRUDsettingsImpl._internal();
  factory ICRUDsettingsImpl() => _instance;

  var _settingsBox;

  _initBox() async {
    if (_settingsBox == null) _settingsBox = await Hive.openBox("settings");
  }

  Future<Settings> getSettings() async {
    await _instance._initBox();
    var settings = _instance._settingsBox.values;
    if (settings.length == 0) {
      Settings settingsInstanz = Settings(
        id: 1,
        toleranzbereich: 5,
        vorratskammerNutzen: true,
        letztesRezept_id: -1,
        naehrwerteAnzeigen: true,
      );
      await _instance._settingsBox.add(settingsInstanz);
      return settingsInstanz;
    }
    return settings.elementAt(0);
  }

  Future<int> setSettings(int toleranzbereich, bool vorratskammerNutzen,
      int letztesRezept_id, bool NaehrwerteAnzeigen) async {
    int settingsID = 1;
    Settings settings = Settings(
      id: settingsID,
      toleranzbereich: toleranzbereich,
      vorratskammerNutzen: vorratskammerNutzen,
      letztesRezept_id: letztesRezept_id,
      naehrwerteAnzeigen: NaehrwerteAnzeigen,
    );

    await _instance._settingsBox.putAt(0, settings);

    return settingsID;
  }

  Future<int> deleteSettings(int settingsID) async {
    await _instance._initBox();
    var rezepte = _instance._settingsBox.values;
    for (int i = rezepte.length - 1; i >= 0; i--) {
      if (rezepte.elementAt(i).settingsID == settingsID) {
        await _instance._settingsBox.deleteAt(i);
      }
    }
    return 0;
  }
}
