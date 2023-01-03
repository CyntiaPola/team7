

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';

class AusfuehrungsEnde extends StatefulWidget {
  final stateManager = getIt<KochenRezeptAnzeigenController>();





  @override
  AusfuehrungsEndeState createState() => AusfuehrungsEndeState();
}

class AusfuehrungsEndeState extends State<AusfuehrungsEnde> {

  Bluetoothverbindung_reactive_ble bluetoothverbindung_reactive_ble =
  getIt<Bluetoothverbindung_reactive_ble>();
  var schrittliste;



  @override
  void initState() {
    schrittliste= widget.stateManager.schritteGeben();
    super.initState();

  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var schritt = widget.stateManager.aktuellerSchrittGeben();


    return
      Column(

          children: <Widget>[

            Center(child:SizedBox(height:300,
                width: 300,

                child:
                Center(child: Text("Guten Appetit",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center),))),

                  SizedBox(width: 150,
                      height: 50,

                      child:ElevatedButton(onPressed: (){
                       // bluetoothverbindung_reactive_ble.beenden();

                       // bluetoothverbindung_reactive_ble
                       //     .bluetoothzustandSetzen(0);

                        widget.stateManager.aktuellerSchrittSetzen(-1);

                      }, child:Text("Beenden",
                          style: TextStyle(fontSize: 20)) ))
                ,


            SizedBox(width: 10),
          ]);









  }











}
