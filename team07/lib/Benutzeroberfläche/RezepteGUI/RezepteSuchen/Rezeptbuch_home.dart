import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteAnlegen/RezeptAdden.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteAnzeigen/RezeptAnzeige.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/GescanntesGeraet.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Verbindung.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';
import '../../../Fachlogik/SteuerungsAPI/Rezept.dart';
import '../../../Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';
import 'SplitButton.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';



class Rezeptbuch_home extends StatefulWidget {
  String title = "Rezeptbuch";

  final stateManager = getIt<Rezeptbuch_Controller>();
  final settingsManager = getIt<SettingsController>();
  final stateManager2 = getIt<RezeptAnzeigenController>();
  final stateManagerAdden= getIt<RezeptAnlegenController>();


  @override
  State<Rezeptbuch_home> createState() => _Rezeptbuch_homeState();
}

class _Rezeptbuch_homeState extends State<Rezeptbuch_home> {
  late TextEditingController _kategorieZutatController;
  late TextEditingController _suchController;
  final wiegetoleranzcontroller = TextEditingController();
  Bluetoothverbindung_reactive_ble bluetoothverbindung_reactive_ble =
  getIt<Bluetoothverbindung_reactive_ble>();
  int bluetoothzustand = 0;
  String suchtitel ="";
  List<String> suchkategorie=[];
  List<String> suchAusschlussKategorien=[];

 


  @override
  initState() {
    super.initState();
    _kategorieZutatController = TextEditingController();
    _suchController = TextEditingController();
    wiegetoleranzcontroller.addListener(toleranzListener);
    wiegetoleranzcontroller.text= widget.settingsManager.toleranzNotifier.value.toString();


    sharedPrefsLaden();
  }

  void toleranzListener() {
    String toleranz = wiegetoleranzcontroller.text;
    for (int i = 0; i < toleranz.length; i++) {
      if (toleranz.codeUnitAt(0) < 48 || toleranz.codeUnitAt(0) > 57) {
        wiegetoleranzcontroller.text = "5";
        return;
      }
      if (int.parse(toleranz) < 1) {
        wiegetoleranzcontroller.text = "1";
      }

      if (int.parse(toleranz) > 20) {
        wiegetoleranzcontroller.text = "20";
      }
    }
  }

  Future<void> sharedPrefsLaden() async {
    final prefs = await SharedPreferences.getInstance();
    String? suchfeld = prefs.getString("Suchfeld");
    suchfeld != null
        ? _suchController.text = suchfeld
        : _suchController.text = "";

    String? filterfeld = prefs.getString("Filterfeld");

    filterfeld != null
        ? _kategorieZutatController.text = filterfeld
        : _kategorieZutatController.text = "";
  }

  Future<void> sharedPrefsSpeichern() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("Suchfeld", _suchController.text);
    prefs.setString("Filterfeld", _kategorieZutatController.text);
  }

  @override
  void dispose() {
    sharedPrefsSpeichern();
    wiegetoleranzcontroller.dispose();
    super.dispose();
  }

  Stream<List<int>>? subscriptionStream;

  @override
  Widget build(BuildContext context) {


    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: ValueListenableBuilder<bool>(
              valueListenable: widget.stateManager.suchButtonNotifier,
              builder: (context, state, _) {
                if (state == true)
                  return IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      widget.stateManager.stoebernWiederherstellen();
                      _suchController.text = "";
                      _kategorieZutatController.text = "";
                      suchtitel="";
                      suchkategorie=[];
                      suchAusschlussKategorien=[];


                    },
                  );
                else
                  return Container();
              }),
          title: Text(widget.title),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                widget.stateManagerAdden.zuruecksetzen();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RezeptAdden()));
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                settings(bluetoothzustand);
              },
            )
          ]),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _suchController,
                        decoration: InputDecoration(hintText: 'Rezept suchen'),
                      ))),
              IconButton(
                color: Colors.lightGreen,
                onPressed: () {
                  widget.stateManager.suchen(_suchController.text, widget.stateManager.gibGewaehlteKategorien(), widget.stateManager.gibAusgeschlosseneZutaten());
                  suchtitel=_suchController.text;
                  suchkategorie=widget.stateManager.gibGewaehlteKategorien();
                  suchAusschlussKategorien=widget.stateManager.gibAusgeschlosseneZutaten();
                },
                icon: Icon(Icons.search),
              )
            ]),
            SingleChildScrollView(
              child:Expanded(
    child: Padding(
    padding: EdgeInsets.only(left: 16.0, top: 0.0,right: 16.0,bottom: 0.0),

              child:Container(
                child:Row(
                  children: <Widget>[
              Expanded(
                child:TypeAheadField(
                animationStart: 0,
               animationDuration: Duration.zero,
                textFieldConfiguration:  TextFieldConfiguration(
                    autofocus: false,
                  style: TextStyle(fontSize: 15),
                    controller: _kategorieZutatController,
                    decoration:InputDecoration(hintText: 'Kategorie oder Zutat'),
                ),
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    color: Colors.lightBlue[50]
                ),
                suggestionsCallback: (pattern) async {
                  List<String> matches = await widget.stateManager.gibAlleKategorien();


                  matches.retainWhere((s){
                    return s.toLowerCase().contains(pattern.toLowerCase());
                  });
                  return matches;
                },
                itemBuilder: (context, sone) {
                  return Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child:Text(sone.toString()),
                      )
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _kategorieZutatController.text=suggestion;
                },
              )
              ),

                    IconButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        if (_kategorieZutatController.text != "") {
                          widget.stateManager
                              .kategorieZutatAusschliessen(_kategorieZutatController.text);
                          _kategorieZutatController.text = "";
                        }
                      },
                      icon: Icon(Icons.thumb_down),
                    ),
            
             IconButton(
                color: Colors.lightGreen,
                onPressed: () {
                  if (_kategorieZutatController.text != "") {
                    widget.stateManager
                        .kategorieZutatFiltern(_kategorieZutatController.text);
                    _kategorieZutatController.text = "";
                  }
                },
                icon: Icon(Icons.thumb_up),
              ),
            ]),
                ))
              ),
            ),
            SizedBox(height: 10),
            ValueListenableBuilder<List<String>>(
                valueListenable: widget.stateManager.kategorieZutatenNotifier,
                builder: (context, eingabeliste, _) {
                  return SizedBox(child: buildContentKategorie(eingabeliste, true));
                }),
            ValueListenableBuilder<List<String>>(
                valueListenable: widget.stateManager.kategorieZutatenAusschlussNotifier,
                builder: (context, eingabeliste, _) {
                  return SizedBox(child: buildContentKategorie(eingabeliste, false));
                }),
            ValueListenableBuilder<bool>(
                valueListenable: widget.stateManager.suchButtonNotifier,
                builder: (context, state, _) {
                  return state == true
                      ? ValueListenableBuilder<List<Rezept>>(
                      valueListenable:
                      widget.stateManager.rezeptListeNotifier,
                      builder: (context, rezeptliste, _) {
                        return Expanded(
                            child: ListView.builder(
                                itemCount: rezeptliste.length,
                                itemBuilder: (context, index) {
                                  Rezept rezept = rezeptliste[index];

                                  return Card(
                                      child: ListTile(
                                        onTap: () async { await
                                        widget.stateManager2.RezeptHolen(rezeptliste[index].id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RezeptAnzeige(inAusfuehrung: false , gesucht: true, suchtitel: suchtitel ,suchKategorien: suchkategorie, suchAusschlussZutaten: suchAusschlussKategorien,)));
                                        },
                                        title: Text(rezept.titel+ " ("+rezept.dauer + "min)" ),

                                        leading: Image(image: FileImage(File( rezeptliste[index].bild))),
                                        trailing:
                                        Icon(Icons.arrow_forward_rounded),
                                      ));
                                }));
                      })
                      : ValueListenableBuilder<List<Rezept>>(
                      valueListenable:
                      widget.stateManager.rezeptVorschlaegeNotifier,
                      builder: (context, rezeptliste, _) {
                        return Expanded(
                          child: GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 0),
                              itemCount: rezeptliste.length,
                              itemBuilder: (BuildContext ctx, index) {

                                return InkWell(
                                  onTap: () async {
                                    await
                                    widget.stateManager2.RezeptHolen(rezeptliste[index].id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RezeptAnzeige(inAusfuehrung: false , gesucht: false, suchtitel: suchtitel ,suchKategorien: suchkategorie,suchAusschlussZutaten: suchAusschlussKategorien,)));

                                  },

                                  child: Stack(
                                      children: <Widget>[
                                        Center(child:Image(image: FileImage(File( rezeptliste[index].bild)))),
                                        rezeptliste[index].titel.length>11 ?
                                        Center(child:  Text(rezeptliste[index].titel.substring(0,10)+ "-\n" +rezeptliste[index].titel.substring(10,rezeptliste[index].titel.length), style: TextStyle(
                                color: Colors.white)),  ) :
                                Center(child: Text(rezeptliste[index].titel, style: TextStyle(
                                    color: Colors.white))),

                                      ]
                                  ),
                                );
                              }),
                        );
                      });
                }),


          ]),
    );
  }

  Widget buildContent(List<Rezept> rezepteliste) {
    return ListView.builder(
        itemCount: rezepteliste.length,
        itemBuilder: (context, index) {
          Rezept rezept = rezepteliste[index];

          return Card(
              child: ListTile(
                title: Text(rezept.titel),
                leading: Text(rezept.dauer),
                trailing: Icon(Icons.arrow_forward_rounded),
              ));
        });
  }

  Widget buildContentKategorie(List<String> kategorieZutatliste, bool gewuenscht) {
    List<Widget> ausgabe = [];

    for (String kategorieZutat in kategorieZutatliste) {
      ausgabe.add(SplitButton(text: kategorieZutat, gewuenscht: gewuenscht,));
    }

    return Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0,
        children: ausgabe);
  }

  Future<void> settings(int bluetoothzustand) async {
    widget.settingsManager.gibToleranzbereich();
    widget.settingsManager.gibNaehrwerteAnzeigen();
    widget.settingsManager.gibVorratskammerNutzen();

    showMenu<int>(
        context: context,
        color: Colors.green,
        constraints: const BoxConstraints(
            minWidth: 0.0, maxWidth: 250.0, minHeight: 0.0, maxHeight: 250.0),
        position: RelativeRect.fromLTRB(MediaQuery
            .of(context)
            .size
            .width, 0,
            MediaQuery
                .of(context)
                .size
                .width, 0),
        items: [
          PopupMenuItem(
              value: 1,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(children: [
                      Text("Vorratskammer nutzen"),
                      Checkbox(
                          value: widget.settingsManager.vorratsNotifier.value,
                          onChanged: (bool? value) {
                            widget.settingsManager.vorratsNotifier.value =
                                value;
                            widget.settingsManager.settingsSpeichern();
                            setState(() {});
                          }),
                    ]);
                  })),
          PopupMenuItem(
              value: 2,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(children: [
                      Text("Nährwerte anzeigen     "),
                      Checkbox(
                          value: widget.settingsManager.naehrwertsNotifier
                              .value,
                          onChanged: (bool? value) {
                            widget.settingsManager.naehrwertsNotifier.value =
                                value;
                            widget.settingsManager.settingsSpeichern();
                            setState(() {});
                          }),
                    ]);
                  })),
          PopupMenuItem(
              value: 3,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(children: [
                      Text("Wiegetoleranz:     +/- "),
                      SizedBox(
                          height: 30,
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.end,
                            onTap: () {
                              wiegetoleranzcontroller.text = '';
                            },
                            onChanged: (v) {
                              widget.settingsManager.toleranzNotifier.value =
                                  int.parse(v);
                              widget.settingsManager.settingsSpeichern();

                            },
                            controller: wiegetoleranzcontroller,
                            textInputAction: TextInputAction.done,
                          ))
                    ]);
                  })),
          PopupMenuItem(
              value: 4,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(children: [
                      Expanded(child: Text("Bluetooth ")),
                      StreamBuilder<BleStatus?>(
                          stream: bluetoothverbindung_reactive_ble.state,
                          builder: (context, snapshot) {
                            bluetoothverbindung_reactive_ble
                                .bluetoothzustandHerstellen();
                            if (snapshot.hasData) {
                              switch (snapshot.data) {
                                case BleStatus.unsupported:
                                  return Text("Bluetooth nicht unterstützt");
                                case BleStatus.unauthorized:
                                  return Text("Erlaubnis erteilen");
                                case BleStatus.poweredOff:
                                  return Text("Bluetooth aus");
                                case BleStatus.locationServicesDisabled:
                                  return Text("Ortserlaubnis erteilen");
                                case BleStatus.ready:
                                  return StreamBuilder<Verbindung>(
                                      stream: bluetoothverbindung_reactive_ble
                                          .connectionState,
                                      builder: (context, snapshot) {
                                        return snapshot.data?.connectionstate
                                            .connectionState !=
                                            DeviceConnectionState.connected
                                            ? StreamBuilder<GescanntesGeraet>(
                                            stream:
                                            bluetoothverbindung_reactive_ble
                                                .scanState,
                                            builder: (context, snapshot2) {
                                              if (snapshot2.hasData) {
                                                return ElevatedButton(
                                                    onPressed: snapshot.data
                                                        ?.connectionstate
                                                        .connectionState ==
                                                        DeviceConnectionState
                                                            .connecting
                                                        ? null
                                                        : () async {
                                                      int verbunden= -1;
                                                      while(verbunden!=0){
                                                        verbunden = await bluetoothverbindung_reactive_ble
                                                            .verbinden();
                                                      }

                                                      bluetoothverbindung_reactive_ble
                                                          .bluetoothzustandSetzen(
                                                          2);
                                                    },
                                                    child: Text(
                                                        "${snapshot2
                                                            .data} \n verbinden"));
                                              }
                                              return ElevatedButton(
                                                  onPressed: () {
                                                    bluetoothverbindung_reactive_ble
                                                        .scannen();
                                                    bluetoothverbindung_reactive_ble
                                                        .bluetoothzustandSetzen(
                                                        1);
                                                  },
                                                  child: Text("Scannen"));
                                            })
                                            : ElevatedButton(
                                            onPressed: () {
                                              bluetoothverbindung_reactive_ble
                                                  .beenden();
                                              bluetoothverbindung_reactive_ble
                                                  .bluetoothzustandSetzen(0);
                                            },
                                            child: Text("beenden"));
                                      });

                                default:
                                  return Text("Fehler");
                              }
                            }
                            return const Text('Keine Daten');
                          }),
                    ]);
                  })),

        ]);
  }
}
