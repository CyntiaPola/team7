import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteAnzeigen/RezeptAnzeige.dart';

import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/GescanntesGeraet.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Verbindung.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';

class Bluetoothschritt extends StatefulWidget {
  final stateManager = getIt<KochenRezeptAnzeigenController>();

  final settingsManager = getIt<SettingsController>();

  final kochenManager = getIt<Kochen_Controller>();




  @override
  BluetoothschrittState createState() => BluetoothschrittState();
}

class BluetoothschrittState extends State<Bluetoothschritt> {
  final wiegetoleranzcontroller = TextEditingController();

  double gewogenesGewicht = 0;

  Bluetoothverbindung_reactive_ble bluetoothverbindung_reactive_ble =
      getIt<Bluetoothverbindung_reactive_ble>();
  var schrittliste;

  AudioCache player = AudioCache();

  Future<void> _handelCommand (Map<String, dynamic> command) async {

    switch (command["command"]) {

      case "next":
        widget.stateManager.aktuellerSchrittSetzen(
            widget.stateManager.schrittnotifier.value + 1);
        widget.kochenManager.gekochtesRezeptAktualisieren(
            gewogenesGewicht, widget.stateManager.aktuellerSchrittGeben().zusatz.split(" ")[1], false);
        await widget.kochenManager.gibBerechneteNaehrwerte();
        await widget.kochenManager.DichteLaden();
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
    schrittliste = widget.stateManager.schritteGeben();
    wiegetoleranzcontroller.addListener(toleranzListener);
    super.initState();
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

  @override
  void dispose() {

    wiegetoleranzcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AlanVoice.activate();

    print("dichtewert");
    print(widget.kochenManager.dichteNotifier.value);
    var schritt = widget.stateManager.aktuellerSchrittGeben();

    String zusatzangabe = schritt.zusatzwert.toString() + schritt.zusatz;

    return Column(children: <Widget>[
      SizedBox(
          height: 300,
          width: 300,
          child: Center(
              child: Text("${schritt.anweisung} ",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center))),
      SizedBox(height: 30),
      ValueListenableBuilder<bool>(
          valueListenable:
              bluetoothverbindung_reactive_ble.deviceVerbundenNotifier,
          builder: (context, verbunden, _) {
            if (verbunden) {
              return StreamBuilder<List<int>>(
                  stream: bluetoothverbindung_reactive_ble.datenEmpfangen(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      Iterable<int> daten = snapshot.data as Iterable<int>;
                      gewogenesGewicht =
                          double.parse(String.fromCharCodes(daten));
                      String einheit = zusatzangabe.split(" ")[0];
                      int vergleichswert =schritt.zusatzwert;

                      return ValueListenableBuilder<int>(
                          valueListenable:
                              widget.settingsManager.toleranzNotifier,
                          builder: (context, toleranz, _) {
                            if(einheit == "ml"){
                              vergleichswert =(vergleichswert*widget.kochenManager.dichteNotifier.value).toInt();
                            }
                            if (((double.parse(String.fromCharCodes(daten)) -
                                        vergleichswert)
                                    .abs() <
                                toleranz / 100.0 * vergleichswert)) {
                              player.play("sounds/bing.wav");

                              return Text(
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                  ),
                                  "${String.fromCharCodes(daten)} g / $zusatzangabe");
                            } else {
                              return Text(
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                  "${String.fromCharCodes(daten)} g / $zusatzangabe");
                            }
                          });
                    }
                    return const Text('No data yet');
                  });
            } else {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return StreamBuilder<BleStatus?>(
                    stream: bluetoothverbindung_reactive_ble.state,
                    builder: (context, snapshot) {
                      bluetoothverbindung_reactive_ble
                          .bluetoothzustandHerstellen();
                      if (snapshot.hasData) {
                        switch (snapshot.data) {
                          case BleStatus.unsupported:
                            return const Text("Bluetooth nicht unterstützt");
                          case BleStatus.unauthorized:
                            return const Text("Erlaubnis erteilen");
                          case BleStatus.poweredOff:
                            return const Text("Bluetooth aus");
                          case BleStatus.locationServicesDisabled:
                            return const Text("Ortserlaubnis erteilen");
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
                                                  onPressed: () {
                                                    bluetoothverbindung_reactive_ble
                                                        .verbinden();
                                                    bluetoothverbindung_reactive_ble
                                                        .bluetoothzustandSetzen(
                                                            2);
                                                  },
                                                  child: Text(
                                                      "${snapshot2.data} \n verbinden"));
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
                    });
              });
            }
          }),
      SizedBox(height: 30),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        SizedBox(width: 10),
        SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
                onPressed: () {},
                child:
                    const Text("Menge bearbeiten", style: TextStyle(fontSize: 20)))),
        SizedBox(width: 40),
        SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  widget.stateManager.aktuellerSchrittSetzen(
                      widget.stateManager.schrittnotifier.value + 1);
                  widget.kochenManager.gekochtesRezeptAktualisieren(
                      gewogenesGewicht, schritt.zusatz.split(" ")[1], false);
                  await widget.kochenManager.gibBerechneteNaehrwerte();
                  await widget.kochenManager.DichteLaden();
                  await widget.kochenManager.vorratskammerAnpassen(schritt.zusatz.split(" ")[1], gewogenesGewicht.toInt(), schritt.zusatz.split(" ")[0]);
                },
                child: Text("Ausgeführt", style: TextStyle(fontSize: 20))))
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
        if (newValue == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RezeptAnzeige(
                        inAusfuehrung: true,
                        gesucht: true,
                        suchtitel: "",
                        suchKategorien: [],
                        suchAusschlussZutaten: [],
                      )));
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
        PopupMenuItem(
            value: 2,
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
      ],
    );
  }
}
