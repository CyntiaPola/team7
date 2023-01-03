

import 'package:flutter/cupertino.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import '../service_locator.dart';
import '../SteuerungsAPI/SettingsController.dart';

class SettingsControllerImpl implements SettingsController{

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
  final pageNotifier=ValueNotifier<int>(0);

  ///Zugriffspunkte auf die anderen Controllerklassen, wird zum Vorabladen der Daten benötigt
  Rezeptbuch_Controller rezeptbuch_controller= getIt<Rezeptbuch_Controller>();
  Kochen_Controller kochen_controller =getIt<Kochen_Controller>();



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
  }


  ///Speichert den vom Nutzer eingegebenen Toleranzbereich persistent in DB ein
  void toleranzbereichSpeichern( int toleranzbereich){

  }





}
