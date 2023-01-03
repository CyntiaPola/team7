import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptschritt.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import 'AnspruchStern.dart';
import 'DauerEingabe.dart';
import 'KategorieLeiste.dart';
import 'PortionsEingabe.dart';
import 'SplitButton.dart';
import 'TitelEingabe.dart';
import 'ZutatenListeElement.dart';
import 'NormalSchrittListenElement.dart';

import 'MengenSchrittListenElement.dart';
import 'TimerSchrittListenElement.dart';

class RezeptAdden extends StatefulWidget {
  final stateManager = getIt<RezeptAnlegenController>();

  @override
  RezeptAddenState createState() => RezeptAddenState();
}

class RezeptAddenState extends State<RezeptAdden> {
  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    if(widget.stateManager.bildNotifier.value==""){
      widget.stateManager.setDefaultRezeptBildAusAssets('DefaultRezept.jpg');
    }
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
        title: Text('Rezept hinzufügen'),
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
                    return SizedBox(child: buildKategorieListe(eingabeliste));
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
                      onPressed: () {

                        if(widget.stateManager.checkRezeptZutaten()) {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Rezept gespeichert!')),
                            );
                            widget.stateManager.speichern();
                            Navigator.of(context).pop();
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

  Widget buildKategorieListe(List<String> rezepteliste) {
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
              const SizedBox(
                width: 16,
              ),
              i==widget.stateManager.schrittNotifier.value.length-1 && i>0?
              _addRemoveButtonSchritt(false, i) : Container(),

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

              i==widget.stateManager.schrittNotifier.value.length-1 && i>0?
              _addRemoveButtonSchritt(false, i) : Container(),
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

              i==widget.stateManager.schrittNotifier.value.length-1 && i>0?
              _addRemoveButtonSchritt(false, i) : Container(),
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

          ],
    child: MaterialButton(
      minWidth: 0,
            height: 0,
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
                  size: 25,
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
            minWidth: 0,
            height: 0,
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
