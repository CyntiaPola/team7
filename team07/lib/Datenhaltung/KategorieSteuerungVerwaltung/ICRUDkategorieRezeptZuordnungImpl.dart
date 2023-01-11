import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorieRezeptZuordnung.dart';
import '../DatenhaltungsAPI/kategorieRezeptZuordnung.dart';

class ICRUDkategorieRezeptZuordnungImpl
    implements ICRUDkategorieRezeptZuordnung {
  //Singelton pattern
  static final ICRUDkategorieRezeptZuordnungImpl _instance =
      ICRUDkategorieRezeptZuordnungImpl._internal();
  ICRUDkategorieRezeptZuordnungImpl._internal();
  factory ICRUDkategorieRezeptZuordnungImpl() => _instance;

  var _kategorieRezeptZuordnungBox;

  _initBox() async {
    if (_kategorieRezeptZuordnungBox == null)
      _kategorieRezeptZuordnungBox =
          await Hive.openBox("kategorieRezeptZuordnung");
  }

  Future<Iterable> getKategorieRezeptZuordnungen() async {
    await _instance._initBox();
    var kategorieRezeptZuordnungen =
        _instance._kategorieRezeptZuordnungBox.values;
    return kategorieRezeptZuordnungen;
  }

  Future<KategorieRezeptZuordnung> getKategorieRezeptZuordnung(
      int kr_zuordnung_id) async {
    await _instance._initBox();
    var kategorieRezeptZuordnungen =
        _instance._kategorieRezeptZuordnungBox.values;
    KategorieRezeptZuordnung kategorieRezeptZuordnung =
        kategorieRezeptZuordnungen.firstWhere(
            (element) => element.kr_zuordnung_id == kr_zuordnung_id);
    return kategorieRezeptZuordnung;
  }

  Future<int> deleteKategorieRezeptZuordnungNachRezeptId(int rezept_id) async {
    await _instance._initBox();
    var kategorieRezeptZuordnung =
        _instance._kategorieRezeptZuordnungBox.values;
    for (int i = kategorieRezeptZuordnung.length - 1; i >= 0; i--) {
      if (kategorieRezeptZuordnung.elementAt(i).rezept_id == rezept_id) {
        await _instance._kategorieRezeptZuordnungBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<Iterable> getKategorieRezeptZuordnungByRezeptID(int rezeptid) async {
    await _instance._initBox();
    var kategorieRezeptZuordnungen =
        _instance._kategorieRezeptZuordnungBox.values;

    var kategorieRezeptZuordnung = [];
    for (int i = 0; i < kategorieRezeptZuordnungen.length; i++) {
      if (kategorieRezeptZuordnungen.elementAt(i).rezept_id == rezeptid) {
        kategorieRezeptZuordnung.add(kategorieRezeptZuordnungen.elementAt(i));
      }
    }
    return kategorieRezeptZuordnung;
  }

  Future<int> setKategorieRezeptZuordnung(
      int kategorie_id, int rezept_id) async {
    int kr_zuordnung_id = 0;
    await _instance._initBox();
    int boxlength = _instance._kategorieRezeptZuordnungBox.values.length;
    if (boxlength == 0) {
      kr_zuordnung_id = 1;
    } else {
      int last_kategorie_id =
          _instance._kategorieRezeptZuordnungBox.values.last.kategorie_id;
      kr_zuordnung_id = last_kategorie_id + 1;
    }
    KategorieRezeptZuordnung kategorien = KategorieRezeptZuordnung(
        kr_zuordnung_id: kr_zuordnung_id,
        kategorie_id: kategorie_id,
        rezept_id: rezept_id);
    await _instance._kategorieRezeptZuordnungBox.add(kategorien);

    return kategorie_id;
  }

  Future<int> deleteKategorieRezeptZuordnung(int kr_zuordnung_id) async {
    await _instance._initBox();
    var kr_zuordnungen = _instance._kategorieRezeptZuordnungBox.values;
    for (int i = kr_zuordnungen.length - 1; i >= 0; i--) {
      if (kr_zuordnungen.elementAt(i).kr_zuordnung_id == kr_zuordnung_id) {
        await _instance._kategorieRezeptZuordnungBox.deleteAt(i);
      }
    }
    return 0;
  }
}
