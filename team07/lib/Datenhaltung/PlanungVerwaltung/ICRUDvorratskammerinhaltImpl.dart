import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDvorratskammerinhalt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/vorratskammerinhalt.dart';

class ICRUDvorratskammerinhaltImpl implements ICRUDvorratskammerinhalt {
  //Singelton pattern
  static final ICRUDvorratskammerinhaltImpl _instance =
      ICRUDvorratskammerinhaltImpl._internal();
  ICRUDvorratskammerinhaltImpl._internal();
  factory ICRUDvorratskammerinhaltImpl() => _instance;

  var _vorratskammerinhaltBox;

  _initBox() async {
    if (_vorratskammerinhaltBox == null)
      _vorratskammerinhaltBox = await Hive.openBox("vorratskammerinhalt");
  }

  Future<Vorratskammerinhalt> getVorratskammerinhalt(
      int vorratskammerinhalt_id) async {
    await _instance._initBox();
    var vorratskammerinhalte = _instance._vorratskammerinhaltBox.values;
    Vorratskammerinhalt vorratskammerinhalt = vorratskammerinhalte.firstWhere(
        (element) => element.vorratskammerinhalt_id == vorratskammerinhalt_id);

    return vorratskammerinhalt;
  }

  Future<Iterable?> getVorratskammerinhalte() async {
    await _instance._initBox();
    var vorratskammerinhalte = _instance._vorratskammerinhaltBox.values;
    return vorratskammerinhalte;
  }

  Future<int> setVorratskammerinhalt(
    int zutatsname_id,
    int menge,
    String einheit,
  ) async {
    int vorratskammerinhalt_id = 0;
    await _instance._initBox();
    int boxlength = _instance._vorratskammerinhaltBox.values.length;
    if (boxlength == 0) {
      vorratskammerinhalt_id = 1;
    } else {
      int last_vorratskammerinhalt_id =
          _instance._vorratskammerinhaltBox.values.last.vorratskammerinhalt_id;
      vorratskammerinhalt_id = last_vorratskammerinhalt_id + 1;
    }
    Vorratskammerinhalt vorratskammerinhalt = Vorratskammerinhalt(
        vorratskammerinhalt_id: vorratskammerinhalt_id,
        zutatsname_id: zutatsname_id,
        menge: menge,
        einheit: einheit);
    await _instance._vorratskammerinhaltBox.add(vorratskammerinhalt);

    return vorratskammerinhalt_id;
  }

  Future<int> deleteVorratskammerinhalt(int vorratskammerinhalt_id) async {
    await _instance._initBox();
    var vorratskammerinhalte = _instance._vorratskammerinhaltBox.values;
    for (int i = vorratskammerinhalte.length - 1; i >= 0; i--) {
      if (vorratskammerinhalte.elementAt(i).vorratskammerinhalt_id ==
          vorratskammerinhalt_id) {
        await _instance._vorratskammerinhaltBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<void> updateVorratskammerinhalt(
    int vorratskammerinhalt_id,
    int zutatsname_id,
    int menge,
    String einheit,
  ) async {
    var vorratskammerinhalte = _instance._vorratskammerinhaltBox.values;
    for (int i = vorratskammerinhalte.length - 1; i >= 0; i--) {
      if (vorratskammerinhalte.elementAt(i).vorratskammerinhalt_id ==
          vorratskammerinhalt_id) {
        Vorratskammerinhalt vorratskammerinhalt = Vorratskammerinhalt(
            vorratskammerinhalt_id: vorratskammerinhalt_id,
            zutatsname_id: zutatsname_id,
            menge: menge,
            einheit: einheit);
        await _instance._vorratskammerinhaltBox.putAt(i, vorratskammerinhalt);
      }
    }
  }
}
