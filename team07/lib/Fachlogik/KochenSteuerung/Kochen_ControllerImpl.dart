
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';

import '../service_locator.dart';


class Kochen_ControllerImpl implements Kochen_Controller{

 final count1Notifier= ValueNotifier<int>(-1);
 final count2Notifier= ValueNotifier<int>(-1);
 final startNotifier = ValueNotifier<bool>(false);
 final counternoteditableNotifier= ValueNotifier<bool>(true);
 final schrittschonmalgestartet= ValueNotifier<bool>(false);


  AudioCache player=  AudioCache();

 int audiolaenge=300;

 final timer = ValueNotifier<Timer>(Timer.periodic(
   Duration(seconds: 1),
       (t) {

   },
 ));

 Kochen_ControllerImpl()

 {


 timer.value = (Timer.periodic(
   Duration(seconds: 1),
       (t) {
     _timer();
   },
 ));
}




 ///Leitet den Tabwechsel vom KochenTab auf den SuchenTab ein
 suchen() {
  getIt<SettingsController>().onItemTapped(2);
 }

 ///Zählt den Zähler herunter, wenn er gestartet wurde und löst Ton aus, wenn er bei 0:0 angekommen ist
 _timer(){

   if ((count2Notifier.value > 0 || count1Notifier.value> 0) && startNotifier.value && counternoteditableNotifier.value
   ) {
     audiolaenge=300;

         if (count1Notifier.value == 0) {
           count2Notifier.value--;
           count1Notifier.value = 60;
         }

         count1Notifier.value--;


   }
   else if( startNotifier.value && count1Notifier.value==0 && count2Notifier.value==0 && audiolaenge>0){


     player.play("sounds/Alarm-Clock-Chickens.mp3");
     audiolaenge--;


   }

 }




}