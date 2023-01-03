
abstract class RezeptAnlegenController{


  ///Speichert Anspruch als Farbarray der Länge 5 mit dem Anspruch entsprechend oft gelb und dann schwarz
  ///
  ///kann Listener über Änderungen benachrichtigen
  get anspruchNotifier;

  ///speichert Zutaten als Liste von Objekten mit Name, Menge, Einheit einer Zutat
  ///
  /// kann Listener über Änderungen benachrichtigen

  get zutatenNotifier;

  ///Speichert Rezeptschritte als Liste von Objekten mit Name, Menge, Einheit, Dauer und der Info ob ein Timer- oder Wiegeschritt vorliegt
  ///
  /// kann Listener über Änderungen benachrichtigen
  get  schrittNotifier;

  ///Speichert eine Liste von Kategorien als Strings
  ///
  /// kann Listener über Änderungen benachrichtigen
  get kategorieNotifier;

  ///Speichert den Pfad eines Bildes als String
  ///
  /// kann Listener über Änderungen benachrichtigen
  get bildNotifier;

  ///Speichert den [anspruch] in ein Farbarray der Länge 5 mit [anspruch]-1 gelben Werten und dem Rest schwarz und informiert Listener über Änderung
  void anspruchFestlegen(int i);

  ///Speichert [name], [menge], [einheit] als Zutatsobjekt in eine Liste und informiert Listener über Änderung der Liste
  void zutatHinzufuegen(String name, String menge, String einheit);

  ///Löscht zutat an der [index] -ten Stelle der Zutatenliste und informiert Listener über Änderung
  void zutatLoeschen(int index);

  ///Speichert die übergebenen Parameter als Schritt in eine Liste und informiert Listener über Änderung der Liste
  void schrittHinzufuegen(String name, String zutat, String menge, String einheit, String zeit, bool wiege, bool timer);

  /// Löscht den [indext]-ten Schritt aus der Liste und informiert Listener über Änderung der Liste
  void schrittLoeschen(int index);

  /// Ändert die Art des [index]-ten Schritt in der Liste je nach [art] zu einem Schritt mit Zeitangabe (art=2), Mengenangabe(art=1) oder keiner zusätzlichen Angabe(art=0)
  void schrittAendern(int index, int art);

  ///Speichert [kategorie] als Kategorie in Liste ein und informiert Listener über Änderung der Liste
   void kategorieHinzufuegen(String kategorie);


  ///Löscht Kategorie an der [index]-ten Stelle der Liste und informiert Listener über Änderung der Liste
   void kategorieLoeschen(int index);

  ///Setzt in Controller gespeicherte Attribute des Rezepts auf Defaultwerte zurück
  void resetFuerAbbrechenButton();

  ///Setzt Rezepttitel auf [titel]
  void titelSetzen(String titel);

  ///gibt den  Titel  des Rezepts zurück
  String titelGeben();

  ///Setzt die Dauer des Rezepts auf [dauer]
  void dauerSetzen(String dauer);

  ///gibt die Dauer des Rezepts zurück
  String dauerGeben();

  ///Setzt die Portion des Rezepts auf [portion]
  void portionSetzen(String portion);

  ///Gibt die Portion des Rezepts zurück
  String portionGeben();


  ///Setzt den Pfad des Rezeptbilds auf in assets gespeichertes Defaultbild und informiert Listener über Änderung
  setDefaultRezeptBildAusAssets(String path);


  /// Löst Öffnen der Gallery aus, speichert den Pfad des dort gewählten Bildes und informiert Listener über Änderung
  getFromGallery();

  /// Löst Öffnen der Kamera aus, speichert den Pfad des dort gemachten Bildes und informiert Listener über Änderung
  getFromCamera();

  ///Prüft, ob die in den Schritten angegebenen Zutaten auch im Rezept vorkommen
  bool checkRezeptZutaten();

  speichern();

  ///Setzt alle Attribute dieser Klasse auf ihren Default-Wert
  void zuruecksetzen();

  ///Holt alle Kategorien aus der Datenbank
  Future<List<String>> gibAlleKategorien();


  ///Speichert Änderungen am Rezept mit der entsprechenden [rezeptid] peristent ab
  bearbeitenSpeichern( int rezeptid);




}