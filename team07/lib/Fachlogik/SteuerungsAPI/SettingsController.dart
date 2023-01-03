abstract class SettingsController{


  ///Speichert, ob Vorratskammer benutzen in den TabHandlerSteuerung gewählt wurde
  get vorratsNotifier;

  ///Speichert ob Nährwerte anzeigen in den TabHandlerSteuerung gewählt wurde
  get naehrwertsNotifier;


  ///Speichert den Wiegetoleranzbereich der in den TabHandlerSteuerung angegeben wurde
  ///default -5
  ///kann durch GUI nur auf ganzzahlige Werte zwischen 1 und 20 gesetzt werden
  get toleranzNotifier;

  ///Speichert den aktuell anzuzeigenden Tab als ganzzahliger Wert zwischen 0 und 4
  ///0 - Vorratskammer
  ///1 - Einkaufsliste
  ///2 - RezepteGUI (default)
  ///3 - KochenGUI
  ///4 - Pläne
  get pageNotifier;

  ///Leitet das Wechsel der Tabs abhängig von [index] ein :
  ///0 - Vorratskammer
  ///1 - Einkaufsliste
  ///2 - RezepteGUI
  ///3 - KochenGUI
  ///4 - Pläne
  ///und lädt die fürs erste Anzeigen benötigten Daten
  void onItemTapped(int index);


  ///Speichert den vom Nutzer eingegebenen Toleranzbereich persistent in DB ein
  void toleranzbereichSpeichern( int toleranzbereich);

}
