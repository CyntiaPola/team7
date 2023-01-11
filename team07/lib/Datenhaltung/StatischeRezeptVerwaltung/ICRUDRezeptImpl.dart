import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDRezept.dart';
import '../DatenhaltungsAPI/rezept.dart';

class ICRUDRezeptImpl implements ICRUDRezept {
  //Singelton pattern
  static final ICRUDRezeptImpl _instance = ICRUDRezeptImpl._internal();
  ICRUDRezeptImpl._internal();
  factory ICRUDRezeptImpl() => _instance;

  // RezepteGUI
  var _rezeptBox;

  _initBox() async {
    if (_rezeptBox == null) _rezeptBox = await Hive.openBox("rezepte");
  }

  Future<Rezept> getRezept(int id) async {
    await _instance._initBox();
    var rezepte = _instance._rezeptBox.values;
    Rezept rezept = rezepte.firstWhere((element) => element.rezept_id == id);

    return rezept;
  }

  Future<Iterable> getRezepte() async {
    await _instance._initBox();
    var rezepte = _instance._rezeptBox.values;
    return rezepte;
  }

  Future<Iterable> getRezeptTitel(String titel) async {
    await _instance._initBox();
    var rezepte = _instance._rezeptBox.values;

    return rezepte
        .where((element) =>
            element.titel.toLowerCase().contains(titel.toLowerCase()) == true)
        .toList();
  }

  Future<int> setRezept(
    String titel,
    int dauer,
    int anspruch,
    String bild,
  ) async {
    int rezeptID = 0;
    await _instance._initBox();
    int boxlength = _instance._rezeptBox.values.length;
    if (boxlength == 0) {
      rezeptID = 1;
    } else {
      int last_rezeptID = _instance._rezeptBox.values.last.rezept_id;
      rezeptID = last_rezeptID + 1;
    }
    Rezept rezept = Rezept(
        rezept_id: rezeptID,
        titel: titel,
        dauer: dauer,
        anspruch: anspruch,
        bild: bild);
    await _instance._rezeptBox.add(rezept);

    return rezeptID;
  }

  Future<int> deleteRezept(int rezept_id) async {
    await _instance._initBox();
    var rezepte = _instance._rezeptBox.values;
    for (int i = rezepte.length - 1; i >= 0; i--) {
      if (rezepte.elementAt(i).rezept_id == rezept_id) {
        await _instance._rezeptBox.deleteAt(i);
      }
    }
    return 0;
  }

  Future<void> updateRezept(
    int rezept_id,
    String titel,
    int dauer,
    int anspruch,
    String bild,
  ) async {
    var rezepte = _instance._rezeptBox.values;
    for (int i = rezepte.length - 1; i >= 0; i--) {
      if (rezepte.elementAt(i).rezept_id == rezept_id) {
        Rezept rezept = Rezept(
            rezept_id: rezept_id,
            titel: titel,
            dauer: dauer,
            anspruch: anspruch,
            bild: bild);
        await _instance._rezeptBox.putAt(i, rezept);
      }
    }
  }
}
