import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDgekochtesRezept.dart';

class ICRUDgekochtesRezeptImpl implements ICRUDgekochtesRezept {
  //Singelton pattern
  static final ICRUDgekochtesRezeptImpl _instance =
      ICRUDgekochtesRezeptImpl._internal();
  ICRUDgekochtesRezeptImpl._internal();
  factory ICRUDgekochtesRezeptImpl() => _instance;

  var _gekochtesRezeptBox;

  _initBox() async {
    //Hive.registerAdapter(RezeptAdapter());
    if (_gekochtesRezeptBox == null)
      _gekochtesRezeptBox = await Hive.openBox("gekochtesRezept");
  }
}
