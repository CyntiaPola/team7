import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDschritt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/schritt.dart';

class ICRUDschrittimpl implements ICRUDschritt {
  //Singelton pattern
  static final ICRUDschrittimpl _instance = ICRUDschrittimpl._internal();
  ICRUDschrittimpl._internal();
  factory ICRUDschrittimpl() => _instance;

  var _schrittBox;

  _initBox() async {
    if (_schrittBox == null) _schrittBox = await Hive.openBox("schritte");
  }

  Future<Schritt> getSchritt(int rezept_id, int schrittnummer) async {
    await _instance._initBox();
    var schritte = _instance._schrittBox.values;
    Schritt schritt = schritte.firstWhere((element) =>
        element.rezept_id == rezept_id &&
        element.schrittnummer == schrittnummer);

    return schritt;
  }

  Future<Iterable> getSchritte() async {
    await _instance._initBox();
    var schritte = _instance._schrittBox.values;
    return schritte;
  }

  Future<Iterable> getSchritteByRezeptId(int rezept_id) async {
    await _instance._initBox();
    var schritte = _instance._schrittBox.values;
    var rezeptschritte =
        schritte.where((element) => element.rezept_id == rezept_id);

    return rezeptschritte;
  }

  Future<int> setSchritt(int schrittnummer, int rezept_id, int timer,
      bool waage, String beschreibung) async {
    int schrittID = 0;
    await _instance._initBox();
    int boxlength = _instance._schrittBox.values.length;
    if (boxlength == 0) {
      schrittID = 1;
    } else {
      int last_schrittID = _instance._schrittBox.values.last.schritt_id;
      schrittID = last_schrittID + 1;
    }
    Schritt schritt = Schritt(
        schritt_id: schrittID,
        schrittnummer: schrittnummer,
        rezept_id: rezept_id,
        timer: timer,
        waage: waage,
        beschreibung: beschreibung);
    await _instance._schrittBox.add(schritt);

    return schrittID;
  }

  Future<int> deleteSchritt(int schritt_id) async {
    await _instance._initBox();
    var schritte = _instance._schrittBox.values;
    for (int i = schritte.length - 1; i >= 0; i--) {
      if (schritte.elementAt(i).schritt_id == schritt_id) {
        await _instance._schrittBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<int> deleteSchritteNachRezeptId(int rezept_id) async {
    await _instance._initBox();
    var schritte = _instance._schrittBox.values;
    for (int i = schritte.length - 1; i >= 0; i--) {
      if (schritte.elementAt(i).rezept_id == rezept_id) {
        await _instance._schrittBox.deleteAt(i);
      }
    }
    return 0;
  }
}
