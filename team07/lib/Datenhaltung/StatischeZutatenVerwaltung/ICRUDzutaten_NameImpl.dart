import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';

import 'package:http/http.dart' as http;

class ICRUDzutaten_NameImpl implements ICRUDzutaten_Name {
  //Singelton pattern
  static final ICRUDzutaten_NameImpl _instance =
      ICRUDzutaten_NameImpl._internal();
  ICRUDzutaten_NameImpl._internal();
  factory ICRUDzutaten_NameImpl() => _instance;

  var _zutaten_NameBox;

  _initBox() async {
    //Hive.registerAdapter(RezeptAdapter());
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
    //rezeptBox.close();

    return zutaten_Name;
  }

  Future<int> getZutatenNameId(String name) async {
    await _instance._initBox();
    var zutaten_Namen = _instance._zutaten_NameBox.values;
    var zutaten_Name = zutaten_Namen
        .where((element) => element.deutsch== name);
    //rezeptBox.close();
    if(zutaten_Name.isEmpty){
      return -1;
    }
    else {
      return zutaten_Name.elementAt(0).zutaten_name_id;
    }
  }

  Future<int> deleteZutatenName(int zutaten_Name_id) async {
    await _instance._initBox();
    await _instance._zutaten_NameBox.deleteAt(zutaten_Name_id);
    return 0;
    //rezeptBox.close();
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
    var zutaten_Name =
        zutaten_Namen.where((element) => element.deutsch == deutsch);
    if (zutaten_Name.isEmpty) {



      Zutaten_Name zutaten_Name = Zutaten_Name(
          zutaten_name_id: zutaten_name_id, deutsch: deutsch, english: englisch);
      await _instance._zutaten_NameBox.add(zutaten_Name);
      return zutaten_name_id;
    } else {
      return zutaten_Name.elementAt(0).zutaten_name_id;
    }
    //await _instance._rezeptBox.close();
  }
}
