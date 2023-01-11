import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorie.dart';
import '../DatenhaltungsAPI/kategorie.dart';

class ICRUDkategorieImpl implements ICRUDkategorie {
  //Singelton pattern
  static final ICRUDkategorieImpl _instance = ICRUDkategorieImpl._internal();
  ICRUDkategorieImpl._internal();
  factory ICRUDkategorieImpl() => _instance;

  var _kategorieBox;

  _initBox() async {
    if (_kategorieBox == null) _kategorieBox = await Hive.openBox("kategorie");
  }

  Future<Iterable> getKategorien() async {
    await _instance._initBox();
    var kategorien = _instance._kategorieBox.values;
    return kategorien;
  }

  Future<Kategorie> getKategorie(int kategorie_id) async {
    await _instance._initBox();
    var kategorien = _instance._kategorieBox.values;
    Kategorie kategorie = kategorien
        .firstWhere((element) => element.kategorie_id == kategorie_id);

    return kategorie;
  }

  Future<int> getKategorieIdByName(String kategorie) async {
    await _instance._initBox();
    var kategorien = _instance._kategorieBox.values;

    var kategorieAusgabe =
        kategorien.where((element) => element.kategorie == kategorie);

    if (kategorieAusgabe.isEmpty) {
      return -1;
    } else {
      return kategorieAusgabe.elementAt(0).kategorie_id;
    }
  }

  Future<int> setKategorie(String kategorie) async {
    int kategorie_id = 0;
    await _instance._initBox();
    int boxlength = _instance._kategorieBox.values.length;
    if (boxlength == 0) {
      kategorie_id = 1;
    } else {
      int last_kategorie_id = _instance._kategorieBox.values.last.kategorie_id;
      kategorie_id = last_kategorie_id + 1;
    }

    var kategorienliste = _instance._kategorieBox.values;
    var kategorieVorhanden =
        kategorienliste.where((element) => element.kategorie == kategorie);
    if (kategorieVorhanden.isEmpty) {
      Kategorie kategorien =
          Kategorie(kategorie_id: kategorie_id, kategorie: kategorie);
      await _instance._kategorieBox.add(kategorien);

      return kategorie_id;
    } else {
      return kategorieVorhanden.elementAt(0).kategorie_id;
    }
  }

  Future<int> deleteKategorie(int kategorie_id) async {
    await _instance._initBox();
    var kategorien = _instance._kategorieBox.values;
    for (int i = kategorien.length - 1; i >= 0; i--) {
      if (kategorien.elementAt(i).kategorie_id == kategorie_id) {
        await _instance._kategorieBox.deleteAt(i);
      }
    }
    return 0;
  }
}
