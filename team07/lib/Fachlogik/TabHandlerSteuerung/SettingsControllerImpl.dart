

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDdichte.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDsettings.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import '../../Datenhaltung/DatenhaltungsAPI/settings.dart';
import '../SteuerungsAPI/WochenplanController.dart';
import '../service_locator.dart';
import '../SteuerungsAPI/SettingsController.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import 'package:http/http.dart' as http;



class SettingsControllerImpl implements SettingsController{



  ICRUDsettings settingsSchnittstelle = getIt<ICRUDsettings>();

  ///Speichert, ob Vorratskammer benutzen in den TabHandlerSteuerung gewählt wurde
  final vorratsNotifier=ValueNotifier<bool>(false);
  ///Speichert ob Nährwerte anzeigen in den TabHandlerSteuerung gewählt wurde
  final naehrwertsNotifier=ValueNotifier<bool>(false);
  ///Speichert den Wiegetoleranzbereich der in den TabHandlerSteuerung angegeben wurde
  ///default -5
  ///kann durch GUI nur auf ganzzahlige Werte zwischen 1 und 20 gesetzt werden
  final toleranzNotifier=ValueNotifier<int>(5);

  ///Speichert den aktuell anzuzeigenden Tab als ganzzahliger Wert zwischen 0 und 4
  ///0 - Vorratskammer
  ///1 - Einkaufsliste
  ///2 - RezepteGUI (default)
  ///3 - KochenGUI
  ///4 - Pläne
  final pageNotifier=ValueNotifier<int>(3);





  int letzteRezeptId=-1;

  ///Zugriffspunkte auf die anderen Controllerklassen, wird zum Vorabladen der Daten benötigt
  Rezeptbuch_Controller rezeptbuch_controller= getIt<Rezeptbuch_Controller>();
  Kochen_Controller kochen_controller =getIt<Kochen_Controller>();
  WochenplanController wocheplanController = getIt<WochenplanController>();



  ///Leitet das Wechsel der Tabs abhängig von [index] ein :
  ///0 - Vorratskammer
  ///1 - Einkaufsliste
  ///2 - RezepteGUI
  ///3 - KochenGUI
  ///4 - Pläne
  ///und lädt die fürs erste Anzeigen benötigten Daten
  void onItemTapped(int index) {

    pageNotifier.value=index;

    if(index==2){

     rezeptbuch_controller.gibAlleRezepte();
    }
    else if(index==3){




    }
    else if(index ==4){

      wocheplanController.gibWochenplan();
    }
  }


  ///Speichert die vom Nutzer eingegebenen Settings persistent in der Datenbank ab
  void settingsSpeichern(){
    settingsSchnittstelle.setSettings(toleranzNotifier.value, vorratsNotifier.value, letzteRezeptId, naehrwertsNotifier.value);
  }


  Future<int> gibToleranzbereich() async {

    Settings settings =  await settingsSchnittstelle.getSettings();
    toleranzNotifier.value=settings.toleranzbereich;
    return settings.toleranzbereich;
  }

  Future<bool> gibVorratskammerNutzen() async {

    Settings settings =  await settingsSchnittstelle.getSettings();
    vorratsNotifier.value=settings.vorratskammerNutzen;
    return settings.vorratskammerNutzen;
  }

  Future<bool> gibNaehrwerteAnzeigen() async {

    Settings settings =  await settingsSchnittstelle.getSettings();
    naehrwertsNotifier.value=settings.naehrwerteAnzeigen;
    return settings.naehrwerteAnzeigen;
  }

  Future<int> gibLetzteRezeptId() async {

    Settings settings =  await settingsSchnittstelle.getSettings();
    return settings.letztesRezept_id;
  }

  void setzeLetzteRezeptId(int letzteRezeptId){
    this.letzteRezeptId=letzteRezeptId;
  }
  
  @override
  // TODO: implement schrittnotifier
  get schrittnotifier => throw UnimplementedError();

  Future<bool> DichteLaden() async {

    var dichteDaten= await getIt<ICRUDdichte>().getDichten();
    if(dichteDaten.isNotEmpty){
      return false;
    }

    ByteData data = await rootBundle.load("assets/data/DichteDeutsch.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);


    for (var table in excel.tables.keys) {
      for (int i=1; i<= excel.tables[table]!.maxRows; i++) {

        String begriff=  excel.tables[table]!.cell(CellIndex.indexByString("A$i")).value.toString();
        String dichtewert= excel.tables[table]!.cell(CellIndex.indexByString("B$i")).value.toString();
        String deutsch= excel.tables[table]!.cell(CellIndex.indexByString("C$i")).value.toString();

        if(dichtewert!="null" && dichtewert!= " "&& dichtewert.contains("-")==false) {





          int zutatsname_id = await getIt<ICRUDzutaten_Name>().setZutatenName(
              deutsch, begriff);
          //Variable umbenennen!!!


          getIt<ICRUDdichte>().setDichte(zutatsname_id,  double.parse(
             dichtewert));

        }



      }

    }

    return true;



  }





}
