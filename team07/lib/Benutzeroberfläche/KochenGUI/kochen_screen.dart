import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteAnzeigen/RezeptAnzeige.dart';

import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Schritte_Rezeptanzeige.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';


import 'AusfuehrungsEnde.dart';
import 'Bluetoothschritt.dart';
import 'NormalSchritt.dart';
import 'Timerschritt.dart';


class KochenScreen extends StatefulWidget {
  final stateManager = getIt<KochenRezeptAnzeigenController>();

  KochenRezeptAnzeigenController kochenRezeptAnzeigenController= getIt<KochenRezeptAnzeigenController>();
Kochen_Controller kochen_controller= getIt<Kochen_Controller>();


  @override
  State<KochenScreen> createState() => _KochenScreenState();
}

class _KochenScreenState extends State<KochenScreen> {

  late List<Schritte_Rezeptanzeige> schrittliste;
  final FlutterTts _flutterTts = FlutterTts();


  @override
  void initState() {
  schrittliste= widget.kochenRezeptAnzeigenController.schritteGeben();
    super.initState();
  }
 
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
            leading: Container(),

          title: ValueListenableBuilder<int>(
          valueListenable: widget.kochenRezeptAnzeigenController.schrittnotifier,
        builder: (context, schrittnummer, _)
    {
      return schrittnummer==-1? Text("Kochen") : Text(widget.kochenRezeptAnzeigenController.titelGeben());


    }),

            actions: [

        ValueListenableBuilder<int>(
        valueListenable: widget.kochenRezeptAnzeigenController.schrittnotifier,
            builder: (context, schrittnummer, _) {
              return schrittnummer != -1 ?  settings()
              : Container();
            })

        ]),
        body: SingleChildScrollView(
          child:   ValueListenableBuilder<int>(
    valueListenable: widget.kochenRezeptAnzeigenController.schrittnotifier,
    builder: (context, schrittnummer, _) {


    return schrittnummer==-1 ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[

               SizedBox(
                height: MediaQuery.of(context).size.height-250,
                width: MediaQuery.of(context).size.width,

              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                  "Aktuell ist kein Rezept in der Ausführung",
                  style: TextStyle(
                    fontSize: 40,
                    ),
                    textAlign: TextAlign.center,
                  ),
          )
          ),
        ElevatedButton(
              child: const Text('Rezept suchen'),
              onPressed: () {
                widget.kochen_controller.suchen();
              },
            ),
          ]
          ) :  _schrittwidget(schrittnummer);})
        )
        );

        
  }

  Widget _schrittwidget( int schrittnummer){


    if( schrittnummer>=schrittliste.length){
      _flutterTts.speak("Guten Appetit");

      return AusfuehrungsEnde();
    }
    else if(schrittliste[schrittnummer].wiege) {
     _flutterTts.speak(widget.kochenRezeptAnzeigenController.aktuellerSchrittGeben().anweisung);

      //    await bluetoothverbindung_reactive_ble.scannenVerbindenSubscribe();
      return Bluetoothschritt();


    }

    else if(schrittliste[schrittnummer].zusatzwert==-1){
      _flutterTts.speak(widget.kochenRezeptAnzeigenController.aktuellerSchrittGeben().anweisung);

      return NormalSchritt();
    }
    else{
      _flutterTts.speak(widget.kochenRezeptAnzeigenController.aktuellerSchrittGeben().anweisung);

     return  Timerschritt();

    }

  }


  Widget settings() {
    return
      PopupMenuButton(
        icon: Icon(Icons.settings),
        color: Colors.green,
        onSelected: (newValue) { // add this property
          if(newValue==0){


            widget.stateManager.aktuellerSchrittSetzen(-1);
          }
          if(newValue==1){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RezeptAnzeige(inAusfuehrung: true , gesucht: true, suchtitel: "" ,suchKategorien:[], suchAusschlussZutaten: [],)));

          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Ausführung abbrechen"),
            value: 0,
          ),
          PopupMenuItem(
            child: Text("Rezept anzeigen"),
            value: 1,
          ),

        ],
      );
  }



}