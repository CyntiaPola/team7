import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteAnzeigen/RezeptAnzeige.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';

import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Schritte_Rezeptanzeige.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';


import '../../Datenhaltung/DatenhaltungsAPI/ICRUDdichte.dart';
import 'AusfuehrungsEnde.dart';
import 'Bluetoothschritt.dart';
import 'NormalSchritt.dart';
import 'Timerschritt.dart';


class KochenScreen extends StatefulWidget {

  KochenRezeptAnzeigenController kochenRezeptAnzeigenController= getIt<KochenRezeptAnzeigenController>();
Kochen_Controller kochen_controller= getIt<Kochen_Controller>();


  KochenScreen({super.key});


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
      return schrittnummer==-1? const Text("Kochen") : Text(widget.kochenRezeptAnzeigenController.titelGeben());


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

              child: const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 100.0, right: 10.0, bottom:  0.0),
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
        ),
        );
  }
  


 Widget _schrittwidget( int schrittnummer)  {



    if( schrittnummer>=schrittliste.length){
      _flutterTts.speak("Guten Appetit");
      return AusfuehrungsEnde();
    }
    else if(schrittliste[schrittnummer].wiege) {
     _flutterTts.speak(widget.kochenRezeptAnzeigenController.aktuellerSchrittGeben().anweisung);



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
        icon: const Icon(Icons.settings),
        color: Colors.green,
        onSelected: (newValue) { // add this property
          if(newValue==0){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlertDialog(
                      title: Text('Ausführung stoppen'),
                      content: Text('Ausführung wirklich stoppen?'),
                      actions: <Widget>[
                        TextButton(
                            child: Text('Weiterkochen'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: Text('Bei Appstart fortsetzen'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              widget.kochenRezeptAnzeigenController.aktuellerSchrittSetzen(-1);
                            }),
                        TextButton(
                          child: Text('Endgültig stoppen'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.kochen_controller.letztesRezeptLoeschen();
                            widget.kochenRezeptAnzeigenController.aktuellerSchrittSetzen(-1);
                          },
                        ),
                      ],
                    )));

          }
          if(newValue==1){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RezeptAnzeige(inAusfuehrung: true , gesucht: true, suchtitel: "" ,suchKategorien:const [], suchAusschlussZutaten: const [],)));

          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Text("Ausführung abbrechen"),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text("Rezept anzeigen"),
          ),

        ],
      );
  }



}