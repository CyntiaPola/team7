import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutats_Menge.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutats_Menge.dart';

class ICRUDzutats_MengeImpl implements ICRUDzutats_Menge {
  //Singelton pattern
  static final ICRUDzutats_MengeImpl _instance =
      ICRUDzutats_MengeImpl._internal();
  ICRUDzutats_MengeImpl._internal();
  factory ICRUDzutats_MengeImpl() => _instance;

  var _zutats_MengeBox;

  _initBox() async {
    //Hive.registerAdapter(RezeptAdapter());
    if (_zutats_MengeBox == null)
      _zutats_MengeBox = await Hive.openBox("zutats_Menge");
  }

  Future<Iterable> getZutatsMengen() async {
    await _instance._initBox();
    var zutats_Mengen = _instance._zutats_MengeBox.values;
    return zutats_Mengen;
  }

  Future<Zutats_Menge> getZutatsMengenBySchrittid(int schrittid) async {
    await _instance._initBox();
    var zutats_Mengen = _instance._zutats_MengeBox.values;

    var zutats_Menge =
        zutats_Mengen.firstWhere((element) => element.schritt_id == schrittid);
    //rezeptBox.close();

    return zutats_Menge;
  }

  Future<Zutats_Menge> getZutatsMenge(int zutats_Menge_id) async {
    await _instance._initBox();
    var zutats_Mengen = _instance._zutats_MengeBox.values;
    Zutats_Menge zutats_Menge = zutats_Mengen
        .firstWhere((element) => element.zutats_Menge_id == zutats_Menge_id);
    //rezeptBox.close();

    return zutats_Menge;
  }

  Future<int> deleteZutatsMenge(int zutats_Menge_id) async {
    await _instance._initBox();
    await _instance._zutats_MengeBox.deleteAt(zutats_Menge_id);
    return 0;
    //rezeptBox.close();
  }

  Future<void> deleteZutatsMengeByRezeptId(int rezept_id) async {
    await _instance._initBox();
    var schrittzutaten = _instance._zutats_MengeBox.values;
    for(int i=schrittzutaten.length-1; i>=0; i--){
      if(schrittzutaten.elementAt(i).rezept_id==rezept_id){
        await _instance._zutats_MengeBox.deleteAt(i);
      }
    }
    //rezeptBox.close();
  }




  Future<int> setZutatsMenge(int rezept_id, int schritt_id, int zutaten_id,
      int teilmenge, String einheit) async {
    int zutats_Menge_id = 0;
    await _instance._initBox();
    int boxlength = _instance._zutats_MengeBox.values.length;
    if (boxlength == 0) {
      zutats_Menge_id = 1;
    } else {
      int last_zutats_Menge_id =
          _instance._zutats_MengeBox.values.last.zutats_Menge_id;
      zutats_Menge_id = last_zutats_Menge_id + 1;
    }
    Zutats_Menge zutats_Menge = Zutats_Menge(
        zutats_Menge_id: zutats_Menge_id,
        rezept_id: rezept_id,
        schritt_id: schritt_id,
        zutaten_id: zutaten_id,
        teilmenge: teilmenge,
        einheit: einheit);
    await _instance._zutats_MengeBox.add(zutats_Menge);
    //await _instance._rezeptBox.close();

    return zutats_Menge_id;
  }
}
