import 'package:flutter/cupertino.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDeinkaufsliste.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/einkaufsliste.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Einkaufsliste_Controller.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Benutzeroberfläche/EinkaufeGUI/EinkaufeHome.dart';
import '../../Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import '../../Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';

class Einkaufsliste_ControllerImpl implements Einkaufsliste_Controller{

  late bool language;

  // late List<EinkaufeModel> guiList = [];
  late Map<int,EinkaufeModel> guiList = {};


  late List<Zutaten_Name> namenList = [];

  ICRUDeinkaufsliste icruDeinkaufsliste  = getIt<ICRUDeinkaufsliste>();

  ICRUDzutaten_Name icruZutatName = getIt<ICRUDzutaten_Name>();

  List<int> deltaLoeschen = [];

  @override
  // TODO: implement einkaufslisteNotifier
  final einkaufslisteNotifier = ValueNotifier<List<EinkaufeModel>>([]);



  @override
  void abhaken(int index) {
    // TODO: implement abhaken
  }


  @override
  Future<void> einkaufsListeAnpassenFrom(EinkaufeModel einkaufeModel) async {
      return einkaufsListeAnpassen(einkaufeModel.name, einkaufeModel.weight, einkaufeModel.unit, einkaufeModel.isChecked);
  }

  @override
  Future<void> einkaufsListeAnpassen(String name, int menge, String einheit, bool dazu) async {
    // TODO: implement einkaufsListeAnpassen

    int zutatsnameId = await icruZutatName.getZutatenNameId(name);

    int einkaufeId = await icruDeinkaufsliste.setEinkaufsliste(zutatsnameId, -1, menge, einheit);

    guiList.putIfAbsent(einkaufeId,()=>EinkaufeModel(einkaufeId,name,menge,einheit));

    einkaufslisteNotifier.value = guiList.entries.map((e) => e.value).toList();

  }

  List<String> getList() {

    List<String> namen = [];
    for (int i = 0; i < namenList.length; i++) {
      namen.add( namenList.elementAt(i).deutsch);
    }
    return namen;
  }

  @override
  Future<void> gibEinkaufsliste() async {
    // TODO: implement gibEinkaufsliste

    language = false;
    var ekl = await icruDeinkaufsliste.getEinkaufslisten();
    var namen = await icruZutatName.getZutatenNamen();

    for (int i = 0; i < namen.length; i++) {
      namenList.add(Zutaten_Name(
          zutaten_name_id: namen.elementAt(i).zutaten_name_id,
          deutsch: namen.elementAt(i).deutsch,
          english: namen.elementAt(i).english));
    }

    for (int i = 0; i < ekl.length; i++) {
      String name = language
          ? namenList
          .firstWhere((element) =>
      element.zutaten_name_id == ekl.elementAt(i).zutatsname_id)
          .deutsch
          : namenList
          .firstWhere((element) =>
      element.zutaten_name_id == ekl.elementAt(i).zutatsname_id)
          .english;



      int einkaufeId = ekl.elementAt(i).einkaufsliste_id;
      int menge = ekl.elementAt(i).menge;
      String einheit =  ekl.elementAt(i).einheit;
      var einkauf = EinkaufeModel(einkaufeId,name,menge,einheit);
      guiList.putIfAbsent(einkaufeId,()=>einkauf);
    }

    einkaufslisteNotifier.value = guiList.entries.map((e) => e.value).toList();


  }

  @override
  void loeschen(int id) {
    // TODO: implement loeschen
    print('loeschen $id');
    deltaLoeschen.add(id);
    guiList.remove(id);
   einkaufslisteNotifier.value = guiList.entries.map((e) => e.value).toList();


  }

  @override
  void speichern() {
    // TODO: implement speichern
  }


  @override
  void suchen(String zutat) {
    print(zutat);

    einkaufslisteNotifier.value = guiList.entries.map((e) => e.value).where((einkaufModel) {
      return einkaufModel.name.toLowerCase().contains(zutat.toLowerCase());
    }).toList();


    print(einkaufslisteNotifier.value);
  }

  @override
  // TODO: implement suchbuttonNotifier
  get suchbuttonNotifier => throw UnimplementedError();

}