import 'package:flutter/cupertino.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDgekochtesRezept.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/GekochtesRezeptGrenzklasse.dart';

import '../SteuerungsAPI/SettingsController.dart';
import '../SteuerungsAPI/WochenplanController.dart';
import '../service_locator.dart';

class WochenplanControllerImpl implements WochenplanController {
  ICRUDgekochtesRezept gekochtesRezeptSchnittstelle = getIt<ICRUDgekochtesRezept>();

  final WochenplanNotifier = ValueNotifier<List<GekochtesRezeptGrenzklasse>>([]);

  /// put all Rezepte in Wochenplannotifier
  @override
  Future<void> gibWochenplan() async {
    Iterable alleGekochtenRezepte = await gekochtesRezeptSchnittstelle.getGekochteRezepte();
    List<GekochtesRezeptGrenzklasse> rezepte = [];

    for (int i = 0; i < alleGekochtenRezepte.length; i++) {
      rezepte.add(GekochtesRezeptGrenzklasse(
          gekochtesRezept_ID: alleGekochtenRezepte.elementAt(i).gekochtesRezept_ID,
          rezept_id: alleGekochtenRezepte.elementAt(i).rezept_id,
          datum: alleGekochtenRezepte.elementAt(i).datum,
          abgeschlossen: alleGekochtenRezepte.elementAt(i).abgeschlossen,
          naehrwert_id: alleGekochtenRezepte.elementAt(i).naehrwert_id,
          status: alleGekochtenRezepte.elementAt(i).isSearchTextEmpty,
          portion: alleGekochtenRezepte.elementAt(i).portion)
      );
    }
    WochenplanNotifier.value = rezepte;
  }

  /// Leitet den Tabwechsel vom PläneTab auf den SuchenTab ein
  @override
  suchen() {
    getIt<SettingsController>().onItemTapped(2);
  }
}
