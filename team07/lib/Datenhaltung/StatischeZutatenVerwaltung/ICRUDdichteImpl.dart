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
    //Hive.registerAdapter(RezeptAdapter());
    if (_dichteBox == null) _dichteBox = await Hive.openBox("dichte");
  }

  Future<Dichte> getDichte(int zutatsname_id) async {
    await _instance._initBox();
    var dichten = _instance._dichteBox.values;
    Dichte dichte =
        dichten.firstWhere((element) => element.zutatsname_id == zutatsname_id);
    //rezeptBox.close();

    return dichte;
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
    //await _instance._rezeptBox.close();

    return dichte_id;
  }

  Future<int> deleteDichte(int dichte_id) async {
    await _instance._initBox();
    await _instance._dichteBox.deleteAt(dichte_id);
    return 0;
    //rezeptBox.close();
  }
}
