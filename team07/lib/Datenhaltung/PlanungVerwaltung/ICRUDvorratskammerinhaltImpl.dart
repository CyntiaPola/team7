import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDvorratskammerinhalt.dart';

class ICRUDvorratskammerinhaltImpl implements ICRUDvorratskammerinhalt {
  //Singelton pattern
  static final ICRUDvorratskammerinhaltImpl _instance =
      ICRUDvorratskammerinhaltImpl._internal();
  ICRUDvorratskammerinhaltImpl._internal();
  factory ICRUDvorratskammerinhaltImpl() => _instance;

  var _vorratskammerinhaltBox;

  _initBox() async {
    //Hive.registerAdapter(RezeptAdapter());
    if (_vorratskammerinhaltBox == null)
      _vorratskammerinhaltBox = await Hive.openBox("vorratskammerinhalt");
  }
}
