import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDsettings.dart';
class ICRUDsettingsImpl implements ICRUDsettings {
  //Singelton pattern
  static final ICRUDsettingsImpl _instance = ICRUDsettingsImpl._internal();
  ICRUDsettingsImpl._internal();
  factory ICRUDsettingsImpl() => _instance;

  var _settingsBox;

  _initBox() async {
    //Hive.registerAdapter(RezeptAdapter());
    if (_settingsBox == null) _settingsBox = await Hive.openBox("settings");
  }
}
