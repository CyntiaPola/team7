import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptschritt.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';
import '../RezepteAnlegen/AnspruchStern.dart';
import '../RezepteAnlegen/DauerEingabe.dart';
import '../RezepteAnlegen/KategorieLeiste.dart';
import '../RezepteAnlegen/PortionsEingabe.dart';
import '../RezepteAnlegen/SplitButton.dart';
import '../RezepteAnlegen/TitelEingabe.dart';
import '../RezepteAnlegen/ZutatenListeElement.dart';
import '../RezepteAnlegen/NormalSchrittListenElement.dart';

import '../RezepteAnlegen/MengenSchrittListenElement.dart';
import '../RezepteAnlegen/TimerSchrittListenElement.dart';
import 'RezeptAnzeige.dart';

class RezeptBearbeiten extends StatefulWidget {
  final stateManager = getIt<RezeptAnlegenController>();


  RezeptAnzeigenController rezeptanzeigencontroller;

  RezeptBearbeiten({required this.rezeptanzeigencontroller});

  @override
  RezeptBearbeitenState createState() => RezeptBearbeitenState();
}

class RezeptBearbeitenState extends State<RezeptBearbeiten> {
  final _formKey = GlobalKey<FormState>();



  ///Übertragen der bereits geladenen Daten aus dem Anzeigecontroller in den Anlegencontroller
  @override
  void initState() {
    widget.stateManager.titelSetzen(widget.rezeptanzeigencontroller.titelGeben());
    widget.stateManager.portionSetzen("1");
    widget.stateManager.dauerSetzen(widget.rezeptanzeigencontroller.dauerGeben().toString());
    widget.stateManager.anspruchFestlegen(widget.rezeptanzeigencontroller.anspruchGebenInt()-1);
    var zutatenVonRezeptAnzeige =widget.rezeptanzeigencontroller.zutatenGeben();
    widget.stateManager.zutatenNotifier.value=[Zutat(name:zutatenVonRezeptAnzeige[0].name , menge: double.parse(zutatenVonRezeptAnzeige[0].menge).toInt().toString(), einheit: zutatenVonRezeptAnzeige[0].einheit)];
    for(int i=1; i< widget.rezeptanzeigencontroller.zutatenGeben().length; i++){
      widget.stateManager.zutatenNotifier.value.add(Zutat(name:zutatenVonRezeptAnzeige[i].name , menge: double.parse(zutatenVonRezeptAnzeige[i].menge).toInt().toString(), einheit: zutatenVonRezeptAnzeige[i].einheit));
    }

    var schritteVonRezeptAnzeige =widget.rezeptanzeigencontroller.schritteGeben();
    var gesplitteterZusatz= schritteVonRezeptAnzeige[0].zusatz.split(' ');
    widget.stateManager.schrittNotifier.value=[
    Rezeptschritt(schritt: schritteVonRezeptAnzeige[0].anweisung,
    zutat: gesplitteterZusatz[gesplitteterZusatz.length-1],
    menge:  schritteVonRezeptAnzeige[0].zusatzwert!=-1 ? schritteVonRezeptAnzeige[0].zusatzwert.toString() : "",
    einheit: gesplitteterZusatz[0],
    zeit:  schritteVonRezeptAnzeige[0].zusatzwert!=-1 ? schritteVonRezeptAnzeige[0].zusatzwert.toString() : "",
    timerschritt: (!schritteVonRezeptAnzeige[0].wiege && schritteVonRezeptAnzeige[0].zusatzwert >-1),
    wiegeschritt: schritteVonRezeptAnzeige[0].wiege)];
    for(int i=1; i< schritteVonRezeptAnzeige.length; i++){
      gesplitteterZusatz= schritteVonRezeptAnzeige[i].zusatz.split(' ');
      widget.stateManager.schrittNotifier.value.add(
        Rezeptschritt(schritt: schritteVonRezeptAnzeige[i].anweisung,
            zutat: gesplitteterZusatz[gesplitteterZusatz.length-1],
            menge:  schritteVonRezeptAnzeige[i].zusatzwert!=-1 ? schritteVonRezeptAnzeige[i].zusatzwert.toString() : "",
            einheit: gesplitteterZusatz[0],
            zeit: schritteVonRezeptAnzeige[i].zusatzwert!=-1 ? schritteVonRezeptAnzeige[i].zusatzwert.toString() : "",
            timerschritt: (!schritteVonRezeptAnzeige[i].wiege && schritteVonRezeptAnzeige[i].zusatzwert >-1),
            wiegeschritt: schritteVonRezeptAnzeige[i].wiege));
    }

    widget.stateManager.bildNotifier.value= widget.rezeptanzeigencontroller.bildGeben();

    widget.stateManager.kategorieNotifier.value= widget.rezeptanzeigencontroller.kategorienGeben();


    super.initState();

  }



  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text('Rezept bearbeiten'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child:
            Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitelEingabe(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: <Widget>[

                    Expanded(child: PortionsEingabe()),
                    Expanded(child: DauerEingabe()),
                    Expanded(child: AnspruchStern())
                  ]),

                  Text(
                    'Zutaten:',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                  ValueListenableBuilder<List<Zutat>>(
                      valueListenable: widget.stateManager.zutatenNotifier,
                      builder: (context, eingabeliste, _) {
                        return Column(children: [..._getZutaten()]);
                      }),
                  Row(children:[Text(
                    'Schritte:',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                    IconButton(onPressed: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Longpress auf Schrittbutton für mehr Optionen')),
                      );}, icon: Icon(Icons.info))
                  ]),
                  ValueListenableBuilder<List<Rezeptschritt>>(
                      valueListenable: widget.stateManager.schrittNotifier,
                      builder: (context, eingabeliste, _) {
                        return Column(children: [..._getSchritte()]);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Kategorien:',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                  KategorieLeiste(),
                  ValueListenableBuilder<List<String>>(
                      valueListenable: widget.stateManager.kategorieNotifier,
                      builder: (context, eingabeliste, _) {
                        return SizedBox(child: buildContentTest(eingabeliste));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Foto:',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.stateManager.getFromGallery();
                            },
                            child: Text("Galerie"),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.stateManager.getFromCamera();
                            },
                            child: Text("Kamera"),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.stateManager.setDefaultRezeptBildAusAssets('DefaultRezept.jpg');
                            },
                            child: Text("Abbrechen"),
                          )),
                    ],
                  ),
                  ValueListenableBuilder<String>(
                      valueListenable: widget.stateManager.bildNotifier,
                      builder: (context, foto, _) {
                        return Container(
                          child:  Image.file(
                            File(foto),
                            fit: BoxFit.cover,
                          )
                          ,
                        );
                      }),

                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.stateManager.resetFuerAbbrechenButton();

                          },
                          child: const Text('Abbrechen'),
                        ),
                      ),
                      Expanded(child: SizedBox(),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {

                            if(widget.stateManager.checkRezeptZutaten()) {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Rezept gespeichert!')),
                                );
                               await  widget.stateManager.bearbeitenSpeichern(widget.rezeptanzeigencontroller.rezeptidGeben());

                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RezeptAnzeige(inAusfuehrung: widget.rezeptanzeigencontroller.inAusfuehrung , gesucht: widget.rezeptanzeigencontroller.gesucht, suchtitel: widget.rezeptanzeigencontroller.suchtitel ,suchKategorien: widget.rezeptanzeigencontroller.suchKategorien,suchAusschlussZutaten: widget.rezeptanzeigencontroller.suchAusschlussZutaten,)));

                              }
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Zutaten stimmen nicht überein')),
                              );
                            }

                          },
                          child: const Text('Speichern'),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Widget buildContentTest(List<String> rezepteliste) {
    List<Widget> ausgabe = [];

    for (int i=0; i< rezepteliste.length; i++) {
      ausgabe.add(SplitButton(text: rezepteliste[i], index: i));
    }

    return  Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0,
      children: ausgabe,
    );
  }

  List<Widget> _getSchritte() {
    List<Widget> neuSchrittList = [];
    if (widget.stateManager.schrittNotifier.value.length == 0) {
      neuSchrittList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: Container()),
            _addRemoveButtonSchritt(true, -1),
          ],
        ),
      ));
      return neuSchrittList;
    }

    for (int i = 0; i < widget.stateManager.schrittNotifier.value.length; i++) {
      if (widget.stateManager.schrittNotifier.value[i].wiegeschritt) {
        neuSchrittList.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(child: MengenSchrittListenElement(i)),
              SizedBox(
                width: 16,
              ),
              _addRemoveButtonSchritt(
                  i == widget.stateManager.schrittNotifier.value.length - 1, i),
            ],
          ),
        ));
      } else if (widget.stateManager.schrittNotifier.value[i].timerschritt) {
        neuSchrittList.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(child: TimerSchrittListenElement(i)),
              SizedBox(
                width: 16,
              ),
              _addRemoveButtonSchritt(
                  i == widget.stateManager.schrittNotifier.value.length - 1, i),
            ],
          ),
        ));
      } else {
        neuSchrittList.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(child: NormalSchrittListenElement(i)),
              SizedBox(
                width: 16,
              ),
              _addRemoveButtonSchritt(
                  i == widget.stateManager.schrittNotifier.value.length - 1, i),
            ],
          ),
        ));
      }
    }
    return neuSchrittList;
  }

  Widget _addRemoveButtonSchritt(bool add, int index) {
    if (add) {
      return CupertinoContextMenu(
          actions: [

            CupertinoContextMenuAction(
              child: const Text('Neuer Schritt mit Mengenangabe',style: TextStyle(
                fontSize: 12,
              ),),
              onPressed: () {
                widget.stateManager
                    .schrittHinzufuegen("", "", "", "", "", true, false);

                Navigator.of(context).pop();
              },
            ),
            CupertinoContextMenuAction(
              child: const Text('Neuer Schritt mit Timerangabe',style: TextStyle(
                fontSize: 12,
              ),),
              onPressed: () {
                widget.stateManager
                    .schrittHinzufuegen("", "", "", "", "", false, true);
                Navigator.of(context).pop();
              },
            ),
            CupertinoContextMenuAction(
              child: const Text('Neuer Schritt ohne Zusatzangabe',style: TextStyle(
                fontSize: 12,
              ),),
              onPressed: () {
                widget.stateManager
                    .schrittHinzufuegen("", "", "", "", "", false, false);

                Navigator.of(context).pop();
              },
            ),
            CupertinoContextMenuAction(
              child: const Text('Schritt löschen',style: TextStyle(
                fontSize: 12,
              ),),
              onPressed: () {
                if(index>0){
                  widget.stateManager.schrittLoeschen(index);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
          child: MaterialButton(
            child: InkWell(
              onTap: () {
                widget.stateManager
                    .schrittHinzufuegen("", "", "", "", "", false, false);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: (add) ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  (add) ? Icons.add : Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {},
          ));
    } else {
      return CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              child: const Text('Dieser Schritt mit Mengenangabe',style: TextStyle(
                fontSize: 12,
              ),),
              onPressed: () {
                widget.stateManager.schrittAendern(index, 1);
                Navigator.of(context).pop();
              },
            ),
            CupertinoContextMenuAction(
              child: const Text('Dieser Schritt mit Timerangabe',style: TextStyle(
                fontSize: 12,
              ),),
              onPressed: () {
                widget.stateManager.schrittAendern(index, 2);
                // Then close the context menu
                Navigator.of(context).pop();
              },
            ),
            CupertinoContextMenuAction(
              child: const Text('Dieser Schritt ohne Zusatzangabe',style: TextStyle(
                fontSize: 12,
              ),),
              onPressed: () {
                widget.stateManager.schrittAendern(index, 0);
                Navigator.of(context).pop();
              },
            ),
          ],
          child: MaterialButton(
            child: InkWell(
              onTap: () {
                widget.stateManager.schrittLoeschen(index);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: (add) ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  (add) ? Icons.add : Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {},
          ));
    }
  }

  List<Widget> _getZutaten() {
    List<Widget> neuZutatenList = [];
    for (int i = 0; i < widget.stateManager.zutatenNotifier.value.length; i++) {
      neuZutatenList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: ZutatenListenElement(i)),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ));
    }
    return neuZutatenList;
  }








}
