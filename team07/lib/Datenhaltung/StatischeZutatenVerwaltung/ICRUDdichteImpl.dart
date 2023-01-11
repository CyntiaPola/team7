import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDdichte.dart';
import '../DatenhaltungsAPI/dichte.dart';

class ICRUDdichteImpl implements ICRUDdichte {
  //Singelton pattern
  static final ICRUDdichteImpl _instance = ICRUDdichteImpl._internal();
  ICRUDdichteImpl._internal();
  factory ICRUDdichteImpl() => _instance;

  var _dichteBox;

  _initBox() async {
    if (_dichteBox == null) _dichteBox = await Hive.openBox("dichte");
  }

  Future<Dichte?> getDichte(int zutatsname_id) async {
    await _instance._initBox();
    var dichten = _instance._dichteBox.values;
    var dichte =
        dichten.where((element) => element.zutatsname_id == zutatsname_id);

    if (dichte.length > 0) {
      return dichte.elementAt(0);
    }

    return null;
  }

  Future<Iterable> getDichten() async {
    await _instance._initBox();
    var dichten = _instance._dichteBox.values;
    return dichten;
  }

  Future<int> setDichte(int zutatsname_id, double volumen_pro_100g) async {
    int dichte_id = 0;
    await _instance._initBox();
    int boxlength = _instance._dichteBox.values.length;
    if (boxlength == 0) {
      dichte_id = 1;
    } else {
      int last_dichte_id = _instance._dichteBox.values.last.dichte_id;
      dichte_id = last_dichte_id + 1;
    }
    Dichte dichte = Dichte(
        dichte_id: dichte_id,
        zutatsname_id: zutatsname_id,
        volumen_pro_100g: volumen_pro_100g);
    await _instance._dichteBox.add(dichte);

    return dichte_id;
  }

  Future<int> deleteDichte(int dichte_id) async {
    await _instance._initBox();
    var dichten = _instance._dichteBox.values;
    for (int i = dichten.length - 1; i >= 0; i--) {
      if (dichten.elementAt(i).dichte_id == dichte_id) {
        await _instance._dichteBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<void> updateDichte(
    int dichte_id,
    int zutatsname_id,
    double volumen_pro_100g,
  ) async {
    var dichten = _instance._dichteBox.values;
    for (int i = dichten.length - 1; i >= 0; i--) {
      if (dichten.elementAt(i).dichte_id == dichte_id) {
        Dichte dichte = Dichte(
            dichte_id: dichte_id,
            zutatsname_id: zutatsname_id,
            volumen_pro_100g: volumen_pro_100g);
        await _instance._dichteBox.putAt(i, dichte);
      }
    }
  }
}
