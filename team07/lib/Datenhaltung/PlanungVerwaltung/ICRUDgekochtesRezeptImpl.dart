import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDgekochtesRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/gekochtesRezept.dart';

class ICRUDgekochtesRezeptImpl implements ICRUDgekochtesRezept {
  //Singelton pattern
  static final ICRUDgekochtesRezeptImpl _instance =
      ICRUDgekochtesRezeptImpl._internal();
  ICRUDgekochtesRezeptImpl._internal();
  factory ICRUDgekochtesRezeptImpl() => _instance;

  var _gekochtesRezeptBox;

  _initBox() async {
    if (_gekochtesRezeptBox == null)
      _gekochtesRezeptBox = await Hive.openBox("gekochtesRezept");
  }

  Future<GekochtesRezept?> getgekochtesRezept(int gekochtesRezept_ID) async {
    await _instance._initBox();
    var gekochteRezepte = _instance._gekochtesRezeptBox.values;
    var gekochtesRezept = gekochteRezepte
        .where((element) => element.gekochtesRezept_ID == gekochtesRezept_ID);

    if (gekochtesRezept.length == 0) {
      return null;
    }

    return gekochtesRezept.elementAt(0);
  }

  Future<Iterable> getGekochteRezepte() async {
    await _instance._initBox();
    var gekochteRezepte = _instance._gekochtesRezeptBox.values;
    return gekochteRezepte;
  }

  Future<int> setGekochteRezept(
    int rezept_id,
    var datum,
    bool abgeschlossen,
    int naehrwert_id,
    int status,
    double portion,
  ) async {
    int gekochtesRezept_ID = 0;
    await _instance._initBox();
    int boxlength = _instance._gekochtesRezeptBox.values.length;
    if (boxlength == 0) {
      gekochtesRezept_ID = 1;
    } else {
      int last_gekochtesRezept_ID =
          _instance._gekochtesRezeptBox.values.last.gekochtesRezept_ID;
      gekochtesRezept_ID = last_gekochtesRezept_ID + 1;
    }

    GekochtesRezept gekochtesRezept = GekochtesRezept(
        gekochtesRezept_ID: gekochtesRezept_ID,
        rezept_id: rezept_id,
        datum: datum,
        abgeschlossen: abgeschlossen,
        naehrwert_id: naehrwert_id,
        status: status,
        portion: portion);
    await _instance._gekochtesRezeptBox.add(gekochtesRezept);

    return gekochtesRezept_ID;
  }

  Future<int> deleteGekochtesRezept(int gekochtesRezept_ID) async {
    await _instance._initBox();
    var gekochteRezepte = _instance._gekochtesRezeptBox.values;
    for (int i = gekochteRezepte.length - 1; i >= 0; i--) {
      if (gekochteRezepte.elementAt(i).gekochtesRezept_ID ==
          gekochtesRezept_ID) {
        await _instance._gekochtesRezeptBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<void> updateGekochtesRezept(
    int gekochtesRezept_ID,
    int rezept_id,
    var datum,
    bool abgeschlossen,
    int naehrwert_id,
    int status,
    double portion,
  ) async {
    var gekochteRezepte = _instance._gekochtesRezeptBox.values;
    for (int i = gekochteRezepte.length - 1; i >= 0; i--) {
      if (gekochteRezepte.elementAt(i).gekochtesRezept_ID ==
          gekochtesRezept_ID) {
        GekochtesRezept gekochtesRezept = GekochtesRezept(
            gekochtesRezept_ID: gekochtesRezept_ID,
            rezept_id: rezept_id,
            datum: datum,
            abgeschlossen: abgeschlossen,
            naehrwert_id: naehrwert_id,
            status: status,
            portion: portion);
        await _instance._gekochtesRezeptBox.putAt(i, gekochtesRezept);
      }
    }
  }
}
