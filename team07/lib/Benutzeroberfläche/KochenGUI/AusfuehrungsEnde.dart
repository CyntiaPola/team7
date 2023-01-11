

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import '../../Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';

class AusfuehrungsEnde extends StatefulWidget {
  final stateManager = getIt<KochenRezeptAnzeigenController>();
  final kochenManager = getIt<Kochen_Controller>();






  @override
  AusfuehrungsEndeState createState() => AusfuehrungsEndeState();
}

class AusfuehrungsEndeState extends State<AusfuehrungsEnde> {

  Bluetoothverbindung_reactive_ble bluetoothverbindung_reactive_ble =
  getIt<Bluetoothverbindung_reactive_ble>();
  var schrittliste;



  Future<void> _handelCommand (Map<String, dynamic> command) async {

    switch (command["command"]) {
      case "next":

        widget.stateManager.aktuellerSchrittSetzen(-1);
        break;
      default:
        debugPrint("Unknown command");
        break;
    }
  }

  @override
  void initState() {

    AlanVoice.onCommand.clear();
    AlanVoice.onCommand.add((command) => _handelCommand(command.data));

    schrittliste= widget.stateManager.schritteGeben();
    super.initState();

  }



  @override
  void dispose() {

    AlanVoice.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AlanVoice.activate();


    var schritt = widget.stateManager.aktuellerSchrittGeben();
    widget.kochenManager.gekochtesRezeptAktualisieren(-1, "", true);

   


    return
      Column(

          children: <Widget>[


            SizedBox(height:50),

                Center(child: Text("Guten Appetit",
                    style: TextStyle(fontSize: 50),
                    textAlign: TextAlign.center),),

            SizedBox(height: 80),

            Padding(
              padding: EdgeInsets.only(left: 6.0, top: 0, right: 6.0, bottom: 0),
              child: Padding(
                  padding:
                  EdgeInsets.only(left: 6.0, top: 0, right: 6.0, bottom: 0),
                  child: Table(border: TableBorder.all(), children: [
                    TableRow(children: [
                      Column(children: [Text('')]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text("pro Portion")]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('gesamt')]),
                    ]),
                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Energie')]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text("${widget.kochenManager.naehrwerte.kcal/widget.stateManager.portionGeben()} kcal")]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${widget.kochenManager.naehrwerte.kcal} kcal')]),
                    ]),
                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Fett')]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text("${widget.kochenManager.naehrwerte.fat/widget.stateManager.portionGeben()} g")]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${widget.kochenManager.naehrwerte.fat} g')]),
                    ]),
                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('davon gesättigte Fettsäuren')]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text("${widget.kochenManager.naehrwerte.saturatedFat/widget.stateManager.portionGeben()} g")]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${widget.kochenManager.naehrwerte.saturatedFat}  g')]),
                    ]),
                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Zucker')]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text("${widget.kochenManager.naehrwerte.sugar/widget.stateManager.portionGeben()} g")]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${widget.kochenManager.naehrwerte.sugar} g')]),
                    ]),

                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Eiweiß')]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text("${widget.kochenManager.naehrwerte.protein/widget.stateManager.portionGeben()} g")]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${widget.kochenManager.naehrwerte.protein} g')]),
                    ]),
                    TableRow(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Salz')]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text("${widget.kochenManager.naehrwerte.sodium/widget.stateManager.portionGeben()} mg")]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Text('${widget.kochenManager.naehrwerte.sodium}  mg')]),
                    ]),
                  ])),
            ),

            SizedBox(height: 50),
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
