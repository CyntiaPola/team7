import 'package:smart_waage/Fachlogik/SteuerungsAPI/Vorratskammerinhalt_Anzeige.dart';

import '../../Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';

abstract class VorratskammerController {
  List<String> getList();

  /// Lädt alle Vorratskammereinträge aus der Datenbank
  Future<int> gibVorratskammer();

  /// Speichert Liste aller Vorratskammereinträge der Klasse und kann Listener über Änderungen benachrichtigen
  get VorratskammerNotifier;

  /// Speichert Liste aller Vorratskammereinträge , die gesuchten Begriff enthalten und kann Listener über Änderungen benachrichtigen
  get SuchlisteNotifier;

  /// Speichert bool, ob Suchbutton gedrückt wurde und kann Listener über Änderung benachrichtigen
  get suchbuttonNotifier;

  // /// Dient der Anpassung der Liste über die Benutzeroberfläche
  // /// Der Parameter [dazu]  steuert, ob die Menge des angegebenen Elements
  // /// erhöht oder verringert werden soll
  // /// Prüft anhand von [name] ob Zutat bereits in Liste liegt und aktualisiert die Liste entsprechend
  // /// ist [dazu] false und die Zutat nicht in der Liste vorhanden, wird die Liste nicht aktualisiert
  // vorratskammerAnpassen(String name, String menge, String einheit, bool dazu);

  int aktualisieren(
      int vorratskammerinhalt_id, String name, int menge, String einheit);

  int erzeugen(String name, int menge, String einheit);

  /// Löscht den Eintrag an der [index]-ten Stelle der Liste
  loeschen(int index);

  /// Durchsucht [VorratskammerNotifier] nach Elementen die [zutat] im Namen enthalten ,
  /// legt die passenden Zutaten in [SuchlisteNotifier] ab und benachrichtigt damit Listener über Änderungen der Liste
  /// setzt [suchbuttonNotifier] auf true
  void suchen(String zutat);

  /// Übernimmt die Änderungen an der Vorratskammer in die Datenbank
  speichern();

  void init() {}
  void sort(int dir);
}
