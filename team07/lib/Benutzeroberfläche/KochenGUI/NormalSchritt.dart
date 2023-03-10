
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/KochenGUI/Timerschritt.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteAnzeigen/RezeptAnzeige.dart';

import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import '../../Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';


class NormalSchritt extends StatefulWidget {
  final stateManager = getIt<KochenRezeptAnzeigenController>();
  final kochenManager = getIt<Kochen_Controller>();






  @override
  NormalSchrittState createState() => NormalSchrittState();
}


class NormalSchrittState extends State<NormalSchritt> {




Future<void> _handelCommand (Map<String, dynamic> command) async {

  switch (command["command"]) {
    case "next":
      widget.stateManager.aktuellerSchrittSetzen(widget.stateManager.schrittnotifier.value+1);

      widget.kochenManager.gekochtesRezeptAktualisieren(-1, "", false);
      await widget.kochenManager.gibBerechneteNaehrwerte();
      await widget.kochenManager.DichteLaden();

      break;
    default:
      debugPrint("Unknown command");
      break;
  }
}
  Bluetoothverbindung_reactive_ble bluetoothverbindung_reactive_ble =
  getIt<Bluetoothverbindung_reactive_ble>();
  var schrittliste;


  @override
  void initState() {




    AlanVoice.onCommand.clear();
    AlanVoice.onCommand.add((command) => _handelCommand(command.data));
   // widget.stateManager.aktuellPortionZurueckSetzen();
    schrittliste= widget.stateManager.schritteGeben();
    super.initState();
  }




 

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     AlanVoice.activate();

    return
      Column(

          children: <Widget>[

            SizedBox(height:300,
                width: 300,

                child:
                Center(child: Text("${widget.stateManager.aktuellerSchrittGeben().anweisung} ",

                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center))),

        
            SizedBox(height: 30),

          

            SizedBox(height: 30),

            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                  ),

                    SizedBox(
                    width: 150,
                      height: 50,
                      child:
                      ElevatedButton(
                          onPressed: ()  async {
                        widget.stateManager.aktuellerSchrittSetzen(widget.stateManager.schrittnotifier.value+1);

                        widget.kochenManager.gekochtesRezeptAktualisieren(-1, "", false);
                        await widget.kochenManager.gibBerechneteNaehrwerte();
                        await widget.kochenManager.DichteLaden();


                          }, child:Text("Ausgef??hrt",
                          style: TextStyle(fontSize: 20)) ))
                ]),


            SizedBox(width: 10),
          ]); 
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
            child: Text("Ausf??hrung abbrechen"),
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


