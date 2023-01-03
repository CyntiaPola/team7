

abstract class Rezeptbuch_Controller{


  ///Speichert, ob Suchbutton in Rezeptsuche gedrückt wurde
  ///
  /// kann Listener über Änderungen benachrichtigen
  get suchButtonNotifier;

  ///Speichert in Filter angegebene Kategorien und Zutaten als Liste
  ///
  /// kann Listener über Änderungen benachrichtigen
  get kategorieZutatenNotifier;

  ///Speichert auszuschließende Zutaten als Liste
  ///
  /// kann Listener über Änderungen benachrichtigen
  get kategorieZutatenAusschlussNotifier;

  ///Speichert Liste nach Titel und/oder Zutaten/Kategorien gefilterte RezepteGUI
  ///
  /// kann Listener über Änderungen benachrichtigen
  get rezeptListeNotifier;

  ///Speichert Liste von Rezeptvorschlägen
  ///
  /// kann Listener über Änderungen benachrichtigen
  get rezeptVorschlaegeNotifier;

  /// Lädt alle RezepteGUI, die [titel] in Titel haben und alle Elemente aus [kategorie] als Zutat oder
  /// Kategorie haben und keine Zutat aus [ausgeschlosseneZutaten] haben in die Rezeptliste und informiert so Listener über Änderung der Liste
  ///
  /// Ist ein Begriff sowohl Zutat als auch Kategorie, so wird dieser als Zutat angesehen, da davon auszugehen
  /// ist, dass ein Rezept, dass eine Kategorie hat, die auch eine Zutat sein könnte, diese Zutat selbst schon
  /// beinhalten muss. Somit können Rezepte, die diesen Suchbegriff nur als Kategorie beinhalten nicht gefunden
  /// werden
  ///
  /// sowohl [titel], als auch [kategorie] und [ausgeschlosseneZutaten] darf leer sein, dann wird die Suche bezüglich
  /// des betreffenden Parameters nicht eingeschränkt
  Future<void> suchen(String titel, List<String> kategorie, List<String> ausgeschlosseneZutaten);

  ///Fügt der Liste der zum Filtern eingegebenen Kategorien/Zutaten [kategorieZutat] hinzu und informiert so Listener über Änderung der Liste
  ///
  ///Löscht eventuell bereits vorhandene gleichnamige Eintragungen, um Dopplungen zu vermeiden
  void kategorieZutatFiltern( String kategorieZutat);

  ///Fügt der Liste der ausgeschlossenen Zutaten [kategorieZutat] hinzu und informiert so Listener über Änderung der Liste
  ///
  /// ///Löscht eventuell bereits vorhandene gleichnamige Eintragungen, um Dopplungen zu vermeiden
  void kategorieZutatAusschliessen(String kategorieZutat);

  ///Löscht ein Element aus der Liste der Zutaten/Kategorien nach denen gefiltert werden soll
  void kategorieZutatLoeschen( String kategorieZutat);

  ///Setzt den Wert, ob der Suchbutton gerückt wurde zurück auf false und leert die Liste an gefilterten Kategorien und Zutaten
  ///Wird benutzt um nach Suche wieder auf den Suchbildschirm mit den Rezeptvorschlägen zu kommen
  void stoebernWiederherstellen();

  ///Speichert alle RezepteGUI die in der Datenbank sind, zufällig gemischt in der Liste der Rezeptvorschläge und informiert  so Listener, dass sich Liste geändert hat
  Future<void> gibAlleRezepte();

  ///gibt die Liste der Zutaten und Kategorien nach denen gefiltert werden soll zurück
  List<String> gibGewaehlteKategorien();

  ///gibt die Liste der ausgeschlossenen Zutaten zurück
  List<String> gibAusgeschlosseneZutaten();

  ///Gibt alle Kategorien die in der Datenbank sind zurück
  Future<List<String>> gibAlleKategorien();




}