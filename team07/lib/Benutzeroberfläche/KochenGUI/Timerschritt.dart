import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteAnzeigen/RezeptAnzeige.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import '../../Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';



class Timerschritt extends StatefulWidget {
  final stateManager = getIt<KochenRezeptAnzeigenController>();
  final Kochen_Controller kochen_controller= getIt<Kochen_Controller>();

  @override
  TimerschrittState createState() => TimerschrittState();
}

class TimerschrittState extends State<Timerschritt> {
  Bluetoothverbindung_reactive_ble bluetoothverbindung_reactive_ble =
  getIt<Bluetoothverbindung_reactive_ble>();
  var schritt;
  late Timer timer;
  late TextEditingController _countereditor2;
  late TextEditingController _countereditor1;

  var schrittliste;






  @override
  void initState() {
    _countereditor2 = new TextEditingController();
    _countereditor1 = new TextEditingController();
    schritt = widget.stateManager.aktuellerSchrittGeben();

    if(widget.kochen_controller.schrittschonmalgestartet.value==false) {
      schritt = widget.stateManager.aktuellerSchrittGeben();
      widget.kochen_controller.count2Notifier.value = schritt.zusatzwert;
      widget.kochen_controller.count1Notifier.value = 0;
    }

    _countereditor2.text=widget.kochen_controller.count2Notifier.value.toString();
    _countereditor1.text=widget.kochen_controller.count1Notifier.value.toString();
    schrittliste= widget.stateManager.schritteGeben();




    super.initState();

    timer = getIt<Kochen_Controller>().timer.value;

  }

  @override
  void dispose() {
  //  timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.kochen_controller.schrittschonmalgestartet.value==false) {
      schritt = widget.stateManager.aktuellerSchrittGeben();
      widget.kochen_controller.count2Notifier.value = schritt.zusatzwert;
      widget.kochen_controller.count1Notifier.value = 0;
    }

    return Column(children: <Widget>[
        SizedBox(
            height: 250,
            width: 250,
            child: Center(
                child: Text(
                    widget.stateManager.aktuellerSchrittGeben().anweisung,
                style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center),)),
        SizedBox(height: 30),

       Row(children: <Widget>[
         SizedBox(width: 80, height:80,
             child:  MultiValueListenableBuilder(
                 valueListenables: [widget.kochen_controller.count2Notifier,widget.kochen_controller.counternoteditableNotifier ],
                 builder: (context, values, child) {


      _countereditor2.text=values[0].toString();

    return TextField(
          readOnly: values[1],
          controller: _countereditor2,
          onChanged: (v) => {
          if(int.parse(v)>-1 && int.parse(v)<60){
            widget.kochen_controller.count2Notifier.value=int.parse(v)
       }
          },
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        );})),
        Text(":",
            style: TextStyle(fontSize: 30)),
        SizedBox(width: 80, height:80,
            child:

    MultiValueListenableBuilder(
    valueListenables: [widget.kochen_controller.count1Notifier,widget.kochen_controller.counternoteditableNotifier ],
    builder: (context, values, child) {

      _countereditor1.text=values[0].toString();

    return TextField(
              readOnly: values[1],
              controller: _countereditor1,
              onChanged: (v) => {
                if(int.parse(v)>-1 && int.parse(v)<60){
                  widget.kochen_controller.count1Notifier.value=int.parse(v)
                }
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            );})),
         SizedBox(width: 30),

         MultiValueListenableBuilder(
             valueListenables: [widget.kochen_controller.counternoteditableNotifier,widget.kochen_controller.startNotifier],
             builder: (context, values, child) {


               return SizedBox(
          width: 150,
          height: 50,
          child:
          ElevatedButton(
              onPressed: !values[0]? null :() {
                widget.kochen_controller.schrittschonmalgestartet.value=true;
                widget.kochen_controller.startNotifier.value = !widget.kochen_controller.startNotifier.value;

              },
              child: Text(values[1] ? "Stop" : "Start",
                  style: TextStyle(fontSize: 20))));}),]),
      SizedBox(height: 30),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
      SizedBox(width: 10),

    MultiValueListenableBuilder(
    valueListenables: [widget.kochen_controller.counternoteditableNotifier,widget.kochen_controller.startNotifier],
    builder: (context, values, child) {
      return SizedBox
    (
              width: 150,
              height: 50,
              child: ElevatedButton(
                  onPressed: values[1] ? null : () {

                      widget.kochen_controller.counternoteditableNotifier.value=!widget.kochen_controller.counternoteditableNotifier.value;

                  },
                  child: Text(values[0] ? "Timer bearbeiten" : "Zeit übernehmen",
                      style: TextStyle(fontSize: 20))));}),
          SizedBox(width: 40),
          SizedBox(
              width: 150,
              height: 50,

                  child: ElevatedButton(onPressed: ()  {

                    widget.stateManager.aktuellerSchrittSetzen(widget.stateManager.schrittnotifier.value+1);


                    widget.kochen_controller.schrittschonmalgestartet.value=false;


                  }, child:Text("Ausgeführt",
                      style: TextStyle(fontSize: 20)) ))
        ]),
        SizedBox(width: 10),
      ]);
  }

  Widget settings() {
    return PopupMenuButton(
      icon: Icon(Icons.settings),
      color: Colors.green,
      onSelected: (newValue) {
        // add this property
        if (newValue == 0) {
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
