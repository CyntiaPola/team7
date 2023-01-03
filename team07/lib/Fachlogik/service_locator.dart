import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDgekochtesRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorie.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorieRezeptZuordnung.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDnaehrwerte_pro_100g.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDschritt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutats_Menge.dart';
import 'package:smart_waage/Datenhaltung/PlanungVerwaltung/ICRUDgekochtesRezeptImpl.dart';
import 'package:smart_waage/Datenhaltung/StatischeRezeptVerwaltung/ICRUDschrittimpl.dart';
import 'package:smart_waage/Datenhaltung/StatischeRezeptVerwaltung/ICRUDzutatenImpl.dart';
import 'package:smart_waage/Datenhaltung/StatischeRezeptVerwaltung/ICRUDzutats_MengeImpl.dart';
import 'package:smart_waage/Datenhaltung/StatischeZutatenVerwaltung/ICRUDnaehrwerte_pro_100gImpl.dart';
import 'package:smart_waage/Datenhaltung/StatischeZutatenVerwaltung/ICRUDzutaten_NameImpl.dart';
import 'package:smart_waage/Fachlogik/KochenSteuerung/KochenRezeptAnzeigenControllerImpl.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/KochenRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/KochenSteuerung/Kochen_ControllerImpl.dart';
import 'package:smart_waage/Fachlogik/RezepteSteuerung/RezeptAnlegenControllerImpl.dart';
import 'package:smart_waage/Fachlogik/RezepteSteuerung/RezeptAnzeigenControllerImpl.dart';
import 'package:smart_waage/Fachlogik/RezepteSteuerung/Rezeptbuch_ControllerImpl.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';
import 'package:smart_waage/Fachlogik/TabHandlerSteuerung/Bluetoothverbindung_reactive_ble.dart';
import 'package:smart_waage/Fachlogik/TabHandlerSteuerung/SettingsControllerImpl.dart';

import '../Datenhaltung/DatenhaltungsAPI/ICRUDeinkaufsliste.dart';
import '../Datenhaltung/KategorieSteuerungVerwaltung/ICRUDkategorieImpl.dart';
import '../Datenhaltung/KategorieSteuerungVerwaltung/ICRUDkategorieRezeptZuordnungImpl.dart';
import '../Datenhaltung/PlanungVerwaltung/ICRUDeinkaufslisteImpl.dart';
import '../Datenhaltung/StatischeRezeptVerwaltung/ICRUDRezeptImpl.dart';
///Datei für die Zuordnung der getIt-Instancen, hier werden alle Interfaces an ihre jeweilige Implementierung
///gebunden, sodass eine aufrufende Klasse nur den Interfacenamen kennen muss

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<Rezeptbuch_Controller>(
          () => Rezeptbuch_ControllerImpl()
  );
  getIt.registerLazySingleton<RezeptAnlegenController>(
          () => RezeptAnlegenControllerImpl()
  );




  getIt.registerLazySingleton<RezeptAnzeigenController>(
          () => RezeptAnzeigenControllerImpl()
  );

  getIt.registerLazySingleton<SettingsController>(
          () => SettingsControllerImpl()
  );

  getIt.registerLazySingleton<Kochen_Controller>(
          () => Kochen_ControllerImpl()
  );

  getIt.registerLazySingleton<KochenRezeptAnzeigenController>(
          () => KochenRezeptAnzeigenControllerImpl()
  );


  getIt.registerLazySingleton<Bluetoothverbindung_reactive_ble>(
      () => Bluetoothverbindung_reactive_ble(ble: FlutterReactiveBle()));


  getIt.registerLazySingleton<ICRUDRezept>(
          () => ICRUDRezeptImpl()
  );

  getIt.registerLazySingleton<ICRUDschritt>(
          () => ICRUDschrittimpl()
  );

  getIt.registerLazySingleton<ICRUDzutaten>(
          () => ICRUDzutatenImpl()
  );

  getIt.registerLazySingleton<ICRUDzutaten_Name>(
          () => ICRUDzutaten_NameImpl()
  );

  getIt.registerLazySingleton<ICRUDzutats_Menge>(
          () => ICRUDzutats_MengeImpl()
  );

  getIt.registerLazySingleton<ICRUDkategorieRezeptZuordnung>(
          () => ICRUDkategorieRezeptZuordnungImpl()
  );

  getIt.registerLazySingleton<ICRUDkategorie>(
          () => ICRUDkategorieImpl()
  );

  getIt.registerLazySingleton<ICRUDeinkaufsliste>(
      () => ICRUDeinkaufslisteImpl()
  );

  getIt.registerLazySingleton<ICRUDgekochtesRezept>(
          () => ICRUDgekochtesRezeptImpl()
  );

  getIt.registerLazySingleton<ICRUDnaehrwerte_pro_100g>(
          ()=> ICRUDnaehrwerte_pro_100gImpl()
  );





}