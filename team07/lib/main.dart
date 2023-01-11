import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/TabHandlerGUI/AppStart.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/kategorieRezeptZuordnung.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/rezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/schritt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/vorratskammerinhalt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutaten.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutats_Menge.dart';
import 'package:smart_waage/Fachlogik/RezepteSteuerung/Rezeptbuch_ControllerImpl.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/GescanntesGeraet.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Verbindung.dart';
import 'package:smart_waage/Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import 'Datenhaltung/DatenhaltungsAPI/dichte.dart';
import 'Datenhaltung/DatenhaltungsAPI/einkaufsliste.dart';
import 'Datenhaltung/DatenhaltungsAPI/gekochtesRezept.dart';
import 'Datenhaltung/DatenhaltungsAPI/kategorie.dart';
import 'Datenhaltung/DatenhaltungsAPI/naehrwerte_pro_100g.dart';
import 'Datenhaltung/DatenhaltungsAPI/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize Hive and Adapter
  await Hive.initFlutter();
  Hive.registerAdapter(RezeptAdapter());
  Hive.openBox("rezepte"); //Sollte noch über Adapter passieren
  Hive.registerAdapter(SchrittAdapter());
  Hive.openBox("schritte");
  Hive.registerAdapter(ZutatenAdapter());
  Hive.openBox("zutaten");
  Hive.registerAdapter(ZutatenNameAdapter());
  Hive.openBox("zutaten_Name");
  Hive.registerAdapter(ZutatsMengeAdapter());
  Hive.openBox("zutats_Menge");
  Hive.registerAdapter(KategorieAdapter());
  Hive.openBox("kategorie");
  Hive.registerAdapter(KategorieRezeptZuordnungAdapter());
  Hive.openBox("kategorieRezeptZuordnung");
  Hive.registerAdapter(EinkaufslisteAdapter());
  Hive.openBox("einkaufsliste");
  Hive.registerAdapter(Naehrwertepro100gAdapter());
  Hive.openBox("naehrwerte_pro_100g");
  Hive.registerAdapter(SettingsAdapter());
  Hive.openBox("settings");
  Hive.registerAdapter(GekochtesRezeptAdapter());
  Hive.openBox("gekochtesRezept");
  Hive.registerAdapter(VorratskammerinhaltAdapter());
  Hive.openBox("vorratskammerinhalt");

  Hive.registerAdapter(DichteAdapter());
  Hive.openBox("dichte");

  setupGetIt();
  await getIt<SettingsController>().DichteLaden();

  final bluetoothverbindung = getIt<Bluetoothverbindung_reactive_ble>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Rezeptbuch_ControllerImpl>(
            create: (context) => Rezeptbuch_ControllerImpl()),
        StreamProvider<GescanntesGeraet>(
          create: (_) => bluetoothverbindung.scanState,
          initialData: GescanntesGeraet(
            device: DiscoveredDevice(
                name: "test",
                id: '-1',
                serviceData: {},
                manufacturerData: Uint8List(0),
                rssi: 0,
                serviceUuids: []),
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => bluetoothverbindung.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<Verbindung>(
          create: (_) => bluetoothverbindung.connectionState,
          initialData: const Verbindung(
              connectionstate: ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          )),
        ),
      ],
      child: AppStart(),
    ),
  );
}
