import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutaten.dart';

class ICRUDzutatenImpl implements ICRUDzutaten {
  //Singelton pattern
  static final ICRUDzutatenImpl _instance = ICRUDzutatenImpl._internal();
  ICRUDzutatenImpl._internal();
  factory ICRUDzutatenImpl() => _instance;

  var _zutatenBox;

  _initBox() async {
    if (_zutatenBox == null) _zutatenBox = await Hive.openBox("zutaten");
  }

  Future<Iterable> getAllZutaten() async {
    await _instance._initBox();
    var zutaten = _instance._zutatenBox.values;
    return zutaten;
  }

  Future<Iterable> getRezeptZutaten(int rezeptid) async {
    await _instance._initBox();
    var zutaten = _instance._zutatenBox.values;
    var zutatenliste =
        zutaten.where((element) => element.rezept_id == rezeptid);

    return zutatenliste;
    return zutaten;
  }

  Future<void> deleteZutatenNachRezeptId(int rezept_id) async {
    await _instance._initBox();
    var zutaten = _instance._zutatenBox.values;
    for (int i = zutaten.length - 1; i >= 0; i--) {
      if (zutaten.elementAt(i).rezept_id == rezept_id) {
        await _instance._zutatenBox.deleteAt(i);
      }
    }
  }

  Future<int> getRezeptZutatenByName(int rezeptid, int zutatsname_id) async {
    await _instance._initBox();
    var zutaten = _instance._zutatenBox.values;

    var zutatenliste = zutaten.where((element) =>
        element.rezept_id == rezeptid && element.name_id == zutatsname_id);
    if (zutatenliste.length == 0) {
      return -1;
    }
    return zutatenliste.elementAt(0).zutaten_id;
    return zutaten;
  }

  Future<Zutaten> getZutat(int zutaten_id) async {
    await _instance._initBox();
    var alleZutaten = _instance._zutatenBox.values;
    Zutaten zutaten =
        alleZutaten.firstWhere((element) => element.zutaten_id == zutaten_id);

    return zutaten;
  }

  Future<int> deleteZutat(int zutaten_id) async {
    await _instance._initBox();
    var zutaten = _instance._zutatenBox.values;
    for (int i = zutaten.length - 1; i >= 0; i--) {
      if (zutaten.elementAt(i).zutaten_id == zutaten_id) {
        await _instance._zutatenBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<int> setZutat(
      int name_id,
      int rezept_id,
      int naehrwert_id,
      int menge_pp,
      String einheit,
      int volumen_id,
      int masse_id,
      int dichte_id,
      bool skalierbar) async {
    int zutaten_id = 0;
    await _instance._initBox();
    int boxlength = _instance._zutatenBox.values.length;
    if (boxlength == 0) {
      zutaten_id = 1;
    } else {
      int last_zutaten_id = _instance._zutatenBox.values.last.zutaten_id;
      zutaten_id = last_zutaten_id + 1;
    }
    Zutaten zutat = Zutaten(
        zutaten_id: zutaten_id,
        name_id: name_id,
        rezept_id: rezept_id,
        naehrwert_id: naehrwert_id,
        menge_pp: menge_pp,
        einheit: einheit,
        volumen_id: volumen_id,
        masse_id: masse_id,
        dichte_id: dichte_id,
        skalierbar: skalierbar);
    await _instance._zutatenBox.add(zutat);

    return zutaten_id;
  }
}
