import 'package:flutter/material.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDvorratskammerinhalt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/vorratskammerinhalt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/VorratskammerController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Vorratskammerinhalt_Anzeige.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

class VorratskammerControllerImpl implements VorratskammerController {
  ICRUDvorratskammerinhalt vki = getIt<ICRUDvorratskammerinhalt>();
  ICRUDzutaten_Name zni = getIt<ICRUDzutaten_Name>();
  late bool language;
  //late List<Vorratskammerinhalt_Anzeige> guiList;
  //late List<Zutaten_Name> namenList;
  List<int> deltaErzeugen = [];
  List<int> deltaLoeschen = [];
  List<int> deltaAktualisieren = [];
  int _numIndex = 0;

  List<String> getList() {
    List<String> namen = [];
    for (int i = 0; i < namenList.length; i++) {
      namen.add(namenList.elementAt(i).deutsch);
    }

    return namen;
  }

  void init() {
    _numIndex = 0;
    VorratskammerNotifier.value = guiList;
  }

  void sort(int dir) {
    dir == 0
        ? guiList.sort((a, b) => b.name.compareTo(a.name))
        : guiList = guiList.reversed.toList();
    VorratskammerNotifier.value = guiList;
    VorratskammerNotifier.notifyListeners();
  }

  @override
  final VorratskammerNotifier =
      ValueNotifier<List<Vorratskammerinhalt_Anzeige>>([]);

  @override
  Future<int> gibVorratskammer() async {
    guiList = [];
    language = true;

    var kammer = await vki.getVorratskammerinhalte();
    if(kammer!=null) {
      if (namenList.isEmpty) {
        var namen = await zni.getZutatenNamen();
        for (int i = 0; i < namen.length; i++) {
          namenList.add(Zutaten_Name(
              zutaten_name_id: namen
                  .elementAt(i)
                  .zutaten_name_id,
              deutsch: namen
                  .elementAt(i)
                  .deutsch,
              english: namen
                  .elementAt(i)
                  .english));
        }
      }
      print("\nanz zutaten: ${namenList.length}\nanz kammer: ${kammer.length}");

      for (int i = 0; i < kammer.length; i++) {
        String name = language
            ? namenList
            .firstWhere((element) =>
        element.zutaten_name_id == kammer
            .elementAt(i)
            .zutatsname_id)
            .deutsch
            : namenList
            .firstWhere((element) =>
        element.zutaten_name_id == kammer
            .elementAt(i)
            .zutatsname_id)
            .english;
        guiList.add(Vorratskammerinhalt_Anzeige(
            vorratskammer_id: kammer
                .elementAt(i)
                .vorratskammerinhalt_id,
            zutatsname_id: kammer
                .elementAt(i)
                .zutatsname_id,
            name: name,
            menge: kammer
                .elementAt(i)
                .menge,
            einheit: kammer
                .elementAt(i)
                .einheit));
      }
    }

    deltaAktualisieren = [];
    deltaErzeugen = [];
    deltaLoeschen = [];
    _numIndex = 0;

    VorratskammerNotifier.value = guiList;

    return 1;
  }

  @override
  loeschen(int index) {
    deltaLoeschen.add(index);
    guiList.removeWhere((element) => element.vorratskammer_id == index);
    //VorratskammerNotifier.value = guiList;
    VorratskammerNotifier.notifyListeners();
  }

  @override
  int aktualisieren(
      int vorratskammerinhalt_id, String name, int menge, String einheit) {
    if (!deltaAktualisieren.contains(vorratskammerinhalt_id) &&
        (vorratskammerinhalt_id >= 0))
      deltaAktualisieren.add(vorratskammerinhalt_id);

    int anz = namenList.where((element) => element.deutsch == name).length;
    if (anz == 0) return 1;
    //if (anz > 1) return 2;

    int nameID = namenList
        .firstWhere((element) => element.deutsch == name)
        .zutaten_name_id;

    int index = guiList.indexOf(guiList.firstWhere(
        (element) => element.vorratskammer_id == vorratskammerinhalt_id));
    guiList[index].zutatsname_id = nameID;
    guiList[index].menge = menge;
    guiList[index].einheit = einheit;
    guiList[index].name = name;

    //VorratskammerNotifier.value = guiList;
    VorratskammerNotifier.notifyListeners();

    return 0;
  }

  @override
  int erzeugen(String name, int menge, String einheit) {
    _numIndex--;
    deltaErzeugen.add(_numIndex);

    int anz = namenList.where((element) => element.deutsch == name).length;
    if (anz == 0) return 1;
    //if (anz > 1) return 2;

    int nameID = namenList
        .firstWhere((element) => element.deutsch == name)
        .zutaten_name_id;

    guiList.add(Vorratskammerinhalt_Anzeige(
        vorratskammer_id: _numIndex,
        zutatsname_id: nameID,
        name: name,
        menge: menge,
        einheit: einheit));

    VorratskammerNotifier.notifyListeners();

    return 0;
  }

  @override
  speichern() async {
    List<int> removeLoeschen = [];
    for (int i = 0; i < deltaLoeschen.length; i++) {
      if (deltaErzeugen.contains(deltaLoeschen[i])) {
        deltaErzeugen.remove(deltaLoeschen[i]);
        removeLoeschen.add(deltaLoeschen[i]);
      }
      if (deltaAktualisieren.contains(deltaLoeschen[i]))
        deltaAktualisieren.remove(deltaLoeschen[i]);
    }
    for (int i = 0; i < removeLoeschen.length; i++)
      deltaLoeschen.remove(removeLoeschen[i]);

    for (int i = 0; i < deltaErzeugen.length; i++) {
      int index = guiList.indexOf(guiList.firstWhere(
          (element) => element.vorratskammer_id == deltaErzeugen[i]));
      await vki.setVorratskammerinhalt(guiList[index].zutatsname_id,
          guiList[index].menge, guiList[index].einheit);
    }

    for (int i = 0; i < deltaAktualisieren.length; i++) {
      int index = guiList.indexOf(guiList.firstWhere(
          (element) => element.vorratskammer_id == deltaAktualisieren[i]));
      await vki.updateVorratskammerinhalt(
          guiList[index].vorratskammer_id,
          guiList[index].zutatsname_id,
          guiList[index].menge,
          guiList[index].einheit);
    }

    for (int i = 0; i < deltaLoeschen.length; i++)
      await vki.deleteVorratskammerinhalt(deltaLoeschen[i]);

    await gibVorratskammer();
    VorratskammerNotifier.notifyListeners();
  }

  @override
  // TODO: implement SuchlisteNotifier
  get SuchlisteNotifier => throw UnimplementedError();

  // @override
  // // TODO: implement VorratskammerNotifier
  // get VorratskammerNotifier => throw UnimplementedError();

  @override
  // TODO: implement suchbuttonNotifier
  get suchbuttonNotifier => throw UnimplementedError();

  @override
  void suchen(String zutat) {
    // TODO: implement suchen
  }

  // @override
  // vorratskammerAnpassen(String name, String menge, String einheit, bool dazu) {
  //   // TODO: implement vorratskammerAnpassen
  //   throw UnimplementedError();
  // }
  List<Vorratskammerinhalt_Anzeige> guiList = [
    // Vorratskammerinhalt_Anzeige(
    //     vorratskammer_id: 1,
    //     zutatsname_id: 7,
    //     name: "Wirsing",
    //     menge: 80,
    //     einheit: "Prise"),
    // Vorratskammerinhalt_Anzeige(
    //     vorratskammer_id: 2,
    //     zutatsname_id: 8,
    //     name: "Peterslilie",
    //     menge: 9000,
    //     einheit: "ml"),
    // Vorratskammerinhalt_Anzeige(
    //     vorratskammer_id: 3,
    //     zutatsname_id: 9,
    //     name: "Reis",
    //     menge: 200,
    //     einheit: "Stück"),
    // Vorratskammerinhalt_Anzeige(
    //     vorratskammer_id: 5,
    //     zutatsname_id: 29,
    //     name: "Meerrettich",
    //     menge: 636,
    //     einheit: "g"),
    // Vorratskammerinhalt_Anzeige(
    //     vorratskammer_id: 32,
    //     zutatsname_id: 39,
    //     name: "Mehl",
    //     menge: 500,
    //     einheit: "g"),
    // Vorratskammerinhalt_Anzeige(
    //     vorratskammer_id: 33,
    //     zutatsname_id: 30,
    //     name: "Zartbitterschokoladen-Eiscreme",
    //     menge: 77,
    //     einheit: "Prise")
  ];
  List<Zutaten_Name> namenList = [
    // Zutaten_Name(zutaten_name_id: 7, deutsch: "Wirsing", english: "english"),
    // Zutaten_Name(
    //     zutaten_name_id: 8, deutsch: "Peterslilie", english: "english"),
    // Zutaten_Name(zutaten_name_id: 9, deutsch: "Reis", english: "english"),
    // Zutaten_Name(
    //     zutaten_name_id: 29, deutsch: "Meerrettich", english: "english"),
    // Zutaten_Name(zutaten_name_id: 39, deutsch: "Mehl", english: "english"),
    // Zutaten_Name(
    //     zutaten_name_id: 30,
    //     deutsch: "Zartbitterschokoladen-Eiscreme",
    //     english: "english")
  ];
}
