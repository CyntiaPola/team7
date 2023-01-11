import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDnaehrwerte_pro_100g.dart';

import '../DatenhaltungsAPI/naehrwerte_pro_100g.dart';

class ICRUDnaehrwerte_pro_100gImpl implements ICRUDnaehrwerte_pro_100g {
  //Singelton pattern
  static final ICRUDnaehrwerte_pro_100gImpl _instance =
      ICRUDnaehrwerte_pro_100gImpl._internal();
  ICRUDnaehrwerte_pro_100gImpl._internal();
  factory ICRUDnaehrwerte_pro_100gImpl() => _instance;

  var _naehrwerte_pro_100gBox;

  _initBox() async {
    if (_naehrwerte_pro_100gBox == null)
      _naehrwerte_pro_100gBox = await Hive.openBox("naehrwerte_pro_100g");
  }

  Future<int> setNaehrwerte_pro_100g(
      int zutatsname_id,
      double kcal,
      double fett,
      double gesaettigteFettsaeuren,
      double zucker,
      double eiweiss,
      double salz) async {
    int naehrwerte_pro_100g_id = 0;
    await _instance._initBox();
    int boxlength = _instance._naehrwerte_pro_100gBox.values.length;
    if (boxlength == 0) {
      naehrwerte_pro_100g_id = 1;
    } else {
      int last_naehrwerte_pro_100g_id =
          _instance._naehrwerte_pro_100gBox.values.last.naehrwert_id;
      naehrwerte_pro_100g_id = last_naehrwerte_pro_100g_id + 1;
    }
    var naehrwerte_pro_100g = _instance._naehrwerte_pro_100gBox.values;
    var naehrwert_pro_100g = naehrwerte_pro_100g
        .where((element) => element.zutatsname_id == zutatsname_id);
    if (naehrwert_pro_100g.isEmpty || zutatsname_id == -2) {
      // zutatsname_id=-2 ist für alle Nährwertsangaben
      //für gekochteRezepte gegeben, hier soll stets ein neuer Nährwert angelegt werden

      Naehrwerte_pro_100g naehrwerte = Naehrwerte_pro_100g(
        naehrwert_id: naehrwerte_pro_100g_id,
        zutatsname_id: zutatsname_id,
        kcal: kcal,
        fett: fett,
        gesaettigteFettsaeuren: gesaettigteFettsaeuren,
        zucker: zucker,
        eiweiss: eiweiss,
        salz: salz,
      );
      await _instance._naehrwerte_pro_100gBox.add(naehrwerte);
      return naehrwerte_pro_100g_id;
    } else {
      return naehrwert_pro_100g.elementAt(0).naehrwert_id;
    }
  }

  Future<Naehrwerte_pro_100g?> getNaehrwerte_pro_100g(
      int naehrwerte_pro_100g_id) async {
    await _instance._initBox();
    var naehrwerte_pro_100g = _instance._naehrwerte_pro_100gBox.values;
    var naehrwert_pro_100g = naehrwerte_pro_100g
        .where((element) => element.naehrwert_id == naehrwerte_pro_100g_id);

    if (naehrwert_pro_100g.length == 0) {
      return null;
    } else
      return naehrwert_pro_100g.elementAt(0);
  }

  Future<int> getNaehrwertIdByNameId(int zutatsname_id) async {
    await _instance._initBox();
    var naehrwerte = _instance._naehrwerte_pro_100gBox.values;
    var naehrwert =
        naehrwerte.where((element) => element.zutatsname_id == zutatsname_id);
    if (naehrwert.isEmpty) {
      return -1;
    } else {
      return naehrwert.elementAt(0).zutatsname_id;
    }
  }

  Future<Naehrwerte_pro_100g?> getNaehrwertByNameId(zutatennameid) async {
    await _instance._initBox();
    var naehrwerte = _instance._naehrwerte_pro_100gBox.values;
    var naehrwert =
        naehrwerte.where((element) => element.zutatsname_id == zutatennameid);

    if (naehrwert.length == 0) {
      return null;
    } else
      return naehrwert.elementAt(0);
  }

  Future<Naehrwerte_pro_100g?> getNaehrwertById(int naehrwertid) async {
    await _instance._initBox();
    var naehrwerte = _instance._naehrwerte_pro_100gBox.values;
    var naehrwert =
        naehrwerte.where((element) => element.naehrwert_id == naehrwertid);

    if (naehrwert.length == 0) {
      return null;
    } else
      return naehrwert.elementAt(0);
  }

  Future<int> deleteNaehrwerte_pro_100g(int naehrwert_ID) async {
    await _instance._initBox();
    var naehrwerte = _instance._naehrwerte_pro_100gBox.values;
    for (int i = naehrwerte.length - 1; i >= 0; i--) {
      if (naehrwerte.elementAt(i).naehrwert_id == naehrwert_ID) {
        await _instance._naehrwerte_pro_100gBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<void> updateNaehrwerte_pro_100g(
      int naehrwerte_pro_100g_id,
      int zutatsname_id,
      double kcal,
      double fett,
      double gesaettigteFettsaeuren,
      double zucker,
      double eiweiss,
      double salz) async {
    var naehrwertePro100g = _instance._naehrwerte_pro_100gBox.values;
    for (int i = naehrwertePro100g.length - 1; i >= 0; i--) {
      if (naehrwertePro100g.elementAt(i).naehrwert_id ==
          naehrwerte_pro_100g_id) {
        Naehrwerte_pro_100g naehrwertePro100gGefunden = Naehrwerte_pro_100g(
          naehrwert_id: naehrwerte_pro_100g_id,
          zutatsname_id: zutatsname_id,
          kcal: kcal,
          fett: fett,
          gesaettigteFettsaeuren: gesaettigteFettsaeuren,
          zucker: zucker,
          eiweiss: eiweiss,
          salz: salz,
        );
        await _instance._naehrwerte_pro_100gBox
            .putAt(i, naehrwertePro100gGefunden);
      }
    }
  }
}
