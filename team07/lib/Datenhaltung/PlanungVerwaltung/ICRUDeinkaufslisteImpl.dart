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

    return einkaufsliste;
  }

  Future<int> deleteEinkaufsliste(int einkaufsliste_id) async {
    await _instance._initBox();
    var einkaufslisten = _instance._einkaufslisteBox.values;
    for (int i = einkaufslisten.length - 1; i >= 0; i--) {
      if (einkaufslisten.elementAt(i).einkaufsliste_id == einkaufsliste_id) {
        await _instance._einkaufslisteBox.deleteAt(i);
      }
    }
    return 0;
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

    return einkaufsliste_id;
  }

  Future<void> updateEinkaufsliste(
    int einkaufsliste_id,
    int zutatsname_id,
    int rezept_id,
    int menge,
    String einheit,
  ) async {
    var einkaufslisten = _instance._einkaufslisteBox.values;
    for (int i = einkaufslisten.length - 1; i >= 0; i--) {
      if (einkaufslisten.elementAt(i).einkaufsliste_id == einkaufsliste_id) {
        Einkaufsliste einkaufsliste = Einkaufsliste(
            einkaufsliste_id: einkaufsliste_id,
            zutatsname_id: zutatsname_id,
            rezept_id: rezept_id,
            menge: menge,
            einheit: einheit);
        await _instance._einkaufslisteBox.putAt(i, einkaufsliste);
      }
    }
  }
}
