import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDeinkaufsliste.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/einkaufsliste.dart';

class ICRUDeinkaufslisteImpl implements ICRUDeinkaufsliste {
  //Singelton pattern
  static final ICRUDeinkaufslisteImpl _instance =
      ICRUDeinkaufslisteImpl._internal();
  ICRUDeinkaufslisteImpl._internal();
  factory ICRUDeinkaufslisteImpl() => _instance;

  var _einkaufslisteBox;

  _initBox() async {
    //Hive.registerAdapter(RezeptAdapter());
    if (_einkaufslisteBox == null)
      _einkaufslisteBox = await Hive.openBox("einkaufsliste");
  }

  Future<Iterable> getEinkaufslisten() async {
    await _instance._initBox();
    var einkaufslisten = _instance._einkaufslisteBox.values;
    return einkaufslisten;
  }

  Future<Einkaufsliste> getEinkaufsliste(int einkaufsliste_id) async {
    await _instance._initBox();
    var einkaufslisten = _instance._einkaufslisteBox.values;
    Einkaufsliste einkaufsliste = einkaufslisten
        .firstWhere((element) => element.einkaufsliste_id == einkaufsliste_id);
    //rezeptBox.close();

    return einkaufsliste;
  }

  Future<int> deleteEinkaufsliste(int einkaufsliste_id) async {
    await _instance._initBox();
    await _instance._einkaufslisteBox.deleteAt(einkaufsliste_id);
    return 0;
    //rezeptBox.close();
  }

  Future<int> setEinkaufsliste(
      int zutatsname_id, int rezept_id, int menge, String einheit) async {
    int einkaufsliste_id = 0;
    await _instance._initBox();
    int boxlength = _instance._einkaufslisteBox.values.length;
    if (boxlength == 0) {
      einkaufsliste_id = 1;
    } else {
      int last_einkaufsliste_id =
          _instance._einkaufslisteBox.values.last.einkaufsliste_id;
      einkaufsliste_id = last_einkaufsliste_id + 1;
    }
    Einkaufsliste einkaufsliste = Einkaufsliste(
        einkaufsliste_id: einkaufsliste_id,
        zutatsname_id: zutatsname_id,
        rezept_id: rezept_id,
        menge: menge,
        einheit: einheit);
    await _instance._einkaufslisteBox.add(einkaufsliste);
    //await _instance._rezeptBox.close();

    return einkaufsliste_id;
  }
}
