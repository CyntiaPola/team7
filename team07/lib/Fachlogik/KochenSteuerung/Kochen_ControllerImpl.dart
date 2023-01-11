
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDsettings.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDvorratskammerinhalt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/gekochtesRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/naehrwerte_pro_100g.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';

import '../../Datenhaltung/DatenhaltungsAPI/ICRUDdichte.dart';
import '../../Datenhaltung/DatenhaltungsAPI/ICRUDgekochtesRezept.dart';
import '../../Datenhaltung/DatenhaltungsAPI/ICRUDnaehrwerte_pro_100g.dart';
import '../../Datenhaltung/DatenhaltungsAPI/settings.dart';
import '../SteuerungsAPI/GekochtesRezeptGrenzklasse.dart';
import '../SteuerungsAPI/Naehrwerte.dart';
import '../service_locator.dart';


class Kochen_ControllerImpl implements Kochen_Controller{

  ///Zugriffspunkt auf Naehrwertangaben in der Datenbank
  ICRUDnaehrwerte_pro_100g naehrwertSchnittstelle =
  getIt<ICRUDnaehrwerte_pro_100g>();


  ///Zugriffspunkt auf gekochte/geplante Rezepte in Datenbank
  ICRUDgekochtesRezept gekochtesRezeptSchnittstelle =
  getIt<ICRUDgekochtesRezept>();

  ///Zugriffspunkt auf den Vorratskammerinhalt in der Datenbank
  ICRUDvorratskammerinhalt vorratskammerSchnittstelle = getIt<ICRUDvorratskammerinhalt>();

  ///Zugriffspunkt auf die Zutatsnamen in der Datenbank
  ICRUDzutaten_Name zutatenNameSchnittstelle =getIt<ICRUDzutaten_Name>();

  ///Zugriffspunkt auf die Dichtewerte in der Datenbank
  ICRUDdichte dichteSchnittstelle =getIt<ICRUDdichte>();

  ICRUDsettings settingsSchnittstelle = getIt<ICRUDsettings>();

  final count1Notifier= ValueNotifier<int>(-1);
 final count2Notifier= ValueNotifier<int>(-1);
 final startNotifier = ValueNotifier<bool>(false);
 final counternoteditableNotifier= ValueNotifier<bool>(true);
 final schrittschonmalgestartet= ValueNotifier<bool>(false);

 final dichteNotifier =ValueNotifier<double>(1.0);

 Naehrwerte naehrwerte=Naehrwerte(kcal: -1, fat: -1, saturatedFat: -1, sugar: -1, protein: -1, sodium: -1);


  AudioCache player=  AudioCache();

 int audiolaenge=300;

  GekochtesRezeptGrenzklasse gekochtesRezept = GekochtesRezeptGrenzklasse(gekochtesRezept_ID: -1, rezept_id: -1, datum: DateTime.now(), abgeschlossen: false, naehrwert_id: -1, status: 0, portion: 1.0);

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


 Future<void> vorratskammerAnpassen(String name, int menge, String einheit) async {

   Settings settings = await settingsSchnittstelle.getSettings();
   if(settings.vorratskammerNutzen) {
     int neueMenge = 0;
     var zutatennameid = await zutatenNameSchnittstelle.getZutatenNameId(name);
     var vorratskammerinhalte = await vorratskammerSchnittstelle
         .getVorratskammerinhalte();
     if (vorratskammerinhalte != null) {
       for (int i = 0; i < vorratskammerinhalte.length; i++) {
         if (vorratskammerinhalte
             .elementAt(i)
             .zutatsname_id == zutatennameid && vorratskammerinhalte
             .elementAt(i)
             .menge > 0) {
           if (vorratskammerinhalte
               .elementAt(i)
               .einheit == einheit) {
             neueMenge = vorratskammerinhalte
                 .elementAt(i)
                 .menge - menge;
           }
           else if (vorratskammerinhalte
               .elementAt(i)
               .einheit == 'g') {
             var dichte = await dichteSchnittstelle.getDichte(zutatennameid);
             var dichtewert = 1.0;
             if (dichte != null) {
               dichtewert = dichte!.volumen_pro_100g;
             }

             neueMenge = (vorratskammerinhalte
                 .elementAt(i)
                 .menge - menge * dichtewert).toInt();
           }
           else {
             var dichte = await dichteSchnittstelle.getDichte(zutatennameid);
             var dichtewert = 1.0;
             if (dichte != null) {
               dichtewert = dichte!.volumen_pro_100g;
             }

             neueMenge = (vorratskammerinhalte
                 .elementAt(i)
                 .menge - menge / dichtewert).toInt();
           }
           vorratskammerSchnittstelle.updateVorratskammerinhalt(
               vorratskammerinhalte
                   .elementAt(i)
                   .vorratskammerinhalt_id, vorratskammerinhalte
               .elementAt(i)
               .zutatsname_id, neueMenge, vorratskammerinhalte
               .elementAt(i)
               .einheit);
         }
       }
     }
   }


 }

 Future<int> gekochtesRezeptAnlegenBeiKlickAufKochen(int rezeptid, double portion ) async {


   gekochtesRezept.naehrwert_id= await naehrwertSchnittstelle.setNaehrwerte_pro_100g(-2, 0, 0, 0, 0, 0, 0);
   gekochtesRezept.rezept_id=rezeptid;
   gekochtesRezept.abgeschlossen=false;
   gekochtesRezept.datum=DateTime.now();
   gekochtesRezept.status=0;
   gekochtesRezept.portion=portion;
   gekochtesRezept.gekochtesRezept_ID= await gekochtesRezeptSchnittstelle.setGekochteRezept(gekochtesRezept.rezept_id,gekochtesRezept.datum, gekochtesRezept.abgeschlossen, gekochtesRezept.naehrwert_id, gekochtesRezept.status, gekochtesRezept.portion );

   return gekochtesRezept.gekochtesRezept_ID;
 }

 Future<void> gekochtesRezeptAktualisieren(double menge, String zutat, bool abgeschlossen) async {


   gekochtesRezept.status=gekochtesRezept.status+1;
   gekochtesRezept.abgeschlossen=abgeschlossen;
   //Nährwerte noch aktualisieren und Portionsangabe mit einbeziehen


   

   if(menge>0){
     Naehrwerte_pro_100g? bisherigeNaehrwerte = await getIt<ICRUDnaehrwerte_pro_100g>().getNaehrwerte_pro_100g(gekochtesRezept.naehrwert_id);

     int zutatennameid =
     await getIt<ICRUDzutaten_Name>().getZutatenNameId(zutat);
     var naehrwerte =
     await naehrwertSchnittstelle.getNaehrwertByNameId(zutatennameid);

     if (naehrwerte != null && bisherigeNaehrwerte !=null) {
       if (naehrwerte.kcal != -1 && bisherigeNaehrwerte.kcal != -1) {
         bisherigeNaehrwerte.kcal = bisherigeNaehrwerte.kcal + naehrwerte.kcal/100*menge;
       } else {
         bisherigeNaehrwerte.kcal = -1;
       }
       if (naehrwerte.fett != -1 && bisherigeNaehrwerte.fett != -1) {
         bisherigeNaehrwerte.fett = bisherigeNaehrwerte.fett + naehrwerte.fett/100*menge;
       } else {
         bisherigeNaehrwerte.fett = -1;
       }
       if (naehrwerte.gesaettigteFettsaeuren != -1 && bisherigeNaehrwerte.gesaettigteFettsaeuren != -1) {
         bisherigeNaehrwerte.gesaettigteFettsaeuren = bisherigeNaehrwerte.gesaettigteFettsaeuren + naehrwerte.gesaettigteFettsaeuren/100*menge;
       } else {
         bisherigeNaehrwerte.gesaettigteFettsaeuren = -1;
       }


       if (naehrwerte.zucker != -1 && bisherigeNaehrwerte.zucker != -1) {
         bisherigeNaehrwerte.zucker = bisherigeNaehrwerte.zucker + naehrwerte.zucker/100*menge;
       } else {
         bisherigeNaehrwerte.zucker = -1;
       }

       if (naehrwerte.eiweiss != -1 && bisherigeNaehrwerte.eiweiss != -1) {
         bisherigeNaehrwerte.eiweiss = bisherigeNaehrwerte.eiweiss + naehrwerte.eiweiss/100*menge;
       } else {
         bisherigeNaehrwerte.eiweiss = -1;
       }
       if (naehrwerte.salz != -1 && bisherigeNaehrwerte.salz != -1) {
         bisherigeNaehrwerte.salz = bisherigeNaehrwerte.salz + naehrwerte.salz/100*menge;
       } else {
         bisherigeNaehrwerte.salz = -1;
       }
     }

     naehrwertSchnittstelle.updateNaehrwerte_pro_100g(gekochtesRezept.naehrwert_id, -2, bisherigeNaehrwerte!.kcal, bisherigeNaehrwerte!.fett, bisherigeNaehrwerte!.gesaettigteFettsaeuren, bisherigeNaehrwerte!.zucker, bisherigeNaehrwerte!.eiweiss, bisherigeNaehrwerte!.salz);

   }

   gekochtesRezeptSchnittstelle.updateGekochtesRezept(gekochtesRezept.gekochtesRezept_ID, gekochtesRezept.rezept_id,gekochtesRezept.datum, gekochtesRezept.abgeschlossen, gekochtesRezept.naehrwert_id, gekochtesRezept.status, gekochtesRezept.portion);
 }


 void gekochtesRezeptSetzen(GekochtesRezeptGrenzklasse gekochtesRezept){
   this.gekochtesRezept=gekochtesRezept;
 }


 Future<void> gibBerechneteNaehrwerte() async {

   Naehrwerte_pro_100g? bisherigeNaehrwerte = await getIt<ICRUDnaehrwerte_pro_100g>().getNaehrwerte_pro_100g(gekochtesRezept.naehrwert_id);

   naehrwerte= Naehrwerte(kcal: bisherigeNaehrwerte!.kcal, fat: bisherigeNaehrwerte!.fett, saturatedFat: bisherigeNaehrwerte!.gesaettigteFettsaeuren, sugar: bisherigeNaehrwerte!.zucker, protein: bisherigeNaehrwerte!.eiweiss, sodium: bisherigeNaehrwerte!.salz);



 }

 ///Gibt true zurück, wenn ein unabgeschlossenes, letztes Rezept vorliegt
 Future<bool> unabgeschlossenesRezeptVorhanden() async {
   Settings settings = await settingsSchnittstelle.getSettings();

   int letztesRezeptId= settings.letztesRezept_id;
   if( letztesRezeptId!=-1) {
     var gekochtesRezept = await gekochtesRezeptSchnittstelle
         .getgekochtesRezept(letztesRezeptId);

     if(gekochtesRezept!=null) {
       return gekochtesRezept.abgeschlossen == false;
     }
     else{
       return false;
     }
   }
   else{
     return false;
   }

 }


 ///Löscht letztes unabgeschlossenes Rezept und setzt die Id des letzten Rezepts in den Settings auf -1
 Future <void> letztesRezeptLoeschen() async {
   Settings settings = await settingsSchnittstelle.getSettings();
   int letztesRezeptId= settings.letztesRezept_id;
   settingsSchnittstelle.setSettings(settings.toleranzbereich, settings.vorratskammerNutzen, -1, settings.naehrwerteAnzeigen);
   gekochtesRezeptSchnittstelle.deleteGekochtesRezept(letztesRezeptId);

 }

 ///Lädt letztes Rezept und die dort gespeicherte Portion in den KochenRezeptAnzeigenController
  ///und legt gekochtesRezept  als Grenzklasse  an, falls diese noch nicht abgeschlossen ist
 Future<void> moeglichesLetztesRezeptLaden() async {

   print("wird geladen");
   Settings settings = await settingsSchnittstelle.getSettings();

   int letztesRezeptId= settings.letztesRezept_id;


   var gekochtesRezept= await gekochtesRezeptSchnittstelle.getgekochtesRezept(letztesRezeptId);




   if(gekochtesRezept != null && gekochtesRezept.abgeschlossen==false){


     await getIt<KochenRezeptAnzeigenController>().RezeptHolen(gekochtesRezept.rezept_id);
     GekochtesRezeptGrenzklasse gekochtesRezeptGrenzklasse = GekochtesRezeptGrenzklasse(gekochtesRezept_ID: gekochtesRezept.gekochtesRezept_ID, rezept_id: gekochtesRezept.rezept_id, datum: gekochtesRezept.datum, abgeschlossen: gekochtesRezept.abgeschlossen, naehrwert_id: gekochtesRezept.naehrwert_id, status: gekochtesRezept.status, portion: gekochtesRezept.portion);
     gekochtesRezeptSetzen(gekochtesRezeptGrenzklasse);

     getIt<KochenRezeptAnzeigenController>().portionSetzen(gekochtesRezept.portion);
     getIt<KochenRezeptAnzeigenController>().aktuellerSchrittSetzen(gekochtesRezept.status);




   }
 }

  ///Lädt gekochtesRezept und die dort gespeicherte Portion in den KochenRezeptAnzeigenController
  ///und legt gekochtesRezept als Grenzklasse an, falls diese noch nicht abgeschlossen ist
  Future<void> unabgeschlossenesRezeptLaden(int letztesRezeptId) async {



    var gekochtesRezept= await gekochtesRezeptSchnittstelle.getgekochtesRezept(letztesRezeptId);




    if(gekochtesRezept!= null && gekochtesRezept.abgeschlossen==false){


      await getIt<KochenRezeptAnzeigenController>().RezeptHolen(gekochtesRezept.rezept_id);
      GekochtesRezeptGrenzklasse gekochtesRezeptGrenzklasse = GekochtesRezeptGrenzklasse(gekochtesRezept_ID: gekochtesRezept.gekochtesRezept_ID, rezept_id: gekochtesRezept.rezept_id, datum: gekochtesRezept.datum, abgeschlossen: gekochtesRezept.abgeschlossen, naehrwert_id: gekochtesRezept.naehrwert_id, status: gekochtesRezept.status, portion: gekochtesRezept.portion);
      gekochtesRezeptSetzen(gekochtesRezeptGrenzklasse);

      getIt<KochenRezeptAnzeigenController>().portionSetzen(gekochtesRezept.portion);
      getIt<KochenRezeptAnzeigenController>().aktuellerSchrittSetzen(gekochtesRezept.status);




    }
  }


 Future<double> DichteLaden() async {

   double dichtewert =1;
   List<String> aufgeteilterZusatz= await  getIt<KochenRezeptAnzeigenController>().aktuellerSchrittGeben().zusatz.split(" ");
   if(aufgeteilterZusatz.length>1) {
     String zutatsname = aufgeteilterZusatz[1];
     int zutatsname_id = await getIt<ICRUDzutaten_Name>().getZutatenNameId(
         zutatsname);
     var dichte = await getIt<ICRUDdichte>().getDichte(zutatsname_id);

     if (dichte != null) {
       dichtewert = dichte.volumen_pro_100g;
     }
   }

   dichteNotifier.value=dichtewert;

   return dichtewert;

 }


}