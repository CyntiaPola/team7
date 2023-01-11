import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';

class ICRUDzutaten_NameImpl implements ICRUDzutaten_Name {
  //Singelton pattern
  static final ICRUDzutaten_NameImpl _instance =
      ICRUDzutaten_NameImpl._internal();
  ICRUDzutaten_NameImpl._internal();
  factory ICRUDzutaten_NameImpl() => _instance;

  var _zutaten_NameBox;

  _initBox() async {
    if (_zutaten_NameBox == null)
      _zutaten_NameBox = await Hive.openBox("zutaten_Name");
  }

  Future<Iterable> getZutatenNamen() async {
    await _instance._initBox();
    var zutaten_Namen = _instance._zutaten_NameBox.values;
    return zutaten_Namen;
  }

  Future<Zutaten_Name> getZutatenName(int zutaten_Name_id) async {
    await _instance._initBox();
    var zutaten_Namen = _instance._zutaten_NameBox.values;
    Zutaten_Name zutaten_Name = zutaten_Namen
        .firstWhere((element) => element.zutaten_name_id == zutaten_Name_id);

    return zutaten_Name;
  }

  Future<int> getZutatenNameId(String name) async {
    await _instance._initBox();
    var zutaten_Namen = _instance._zutaten_NameBox.values;
    var zutaten_Name =
        zutaten_Namen.where((element) => element.deutsch == name);

    if (zutaten_Name.isEmpty) {
      return -1;
    } else {
      return zutaten_Name.elementAt(0).zutaten_name_id;
    }
  }

  Future<int> deleteZutatenName(int zutaten_Name_id) async {
    await _instance._initBox();
    var zutaten_Namen = _instance._zutaten_NameBox.values;
    for (int i = zutaten_Namen.length - 1; i >= 0; i--) {
      if (zutaten_Namen.elementAt(i).zutaten_Name_id == zutaten_Name_id) {
        await _instance._zutaten_NameBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<int> setZutatenName(String deutsch, String englisch) async {
    int zutaten_name_id = 0;
    await _instance._initBox();
    int boxlength = _instance._zutaten_NameBox.values.length;
    if (boxlength == 0) {
      zutaten_name_id = 1;
    } else {
      int last_zutaten_name_id =
          _instance._zutaten_NameBox.values.last.zutaten_name_id;
      zutaten_name_id = last_zutaten_name_id + 1;
    }
    var zutaten_Namen = _instance._zutaten_NameBox.values;
    var zutaten_Name = zutaten_Namen.where(
        (element) => element.deutsch.toLowerCase() == deutsch.toLowerCase());
    if (zutaten_Name.isEmpty) {
      Zutaten_Name zutaten_Name = Zutaten_Name(
          zutaten_name_id: zutaten_name_id,
          deutsch: deutsch,
          english: englisch);
      await _instance._zutaten_NameBox.add(zutaten_Name);
      return zutaten_name_id;
    } else {
      return zutaten_Name.elementAt(0).zutaten_name_id;
    }
  }
}
