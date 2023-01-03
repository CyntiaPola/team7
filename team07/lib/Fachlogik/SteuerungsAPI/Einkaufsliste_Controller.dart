abstract class Einkaufsliste_Controller{

  ///Lädt alle Einkaufslisteneinträge aus der Datenbank
  Future<void> gibEinkaufsliste();

     ///Speichert Liste aller Einkaufslisteneinträge der Klasse und kann Listener über Änderungen benachrichtigen
     get EinkaufslisteNotifier;

  ///Speichert Liste aller Einkaufslisteneinträge, die gesuchten Begriff enthalten und kann Listener über Änderungen benachrichtigen
  get SuchlisteNotifier;


  ///Speichert bool, ob Suchbutton gedrückt wurde und kann Listener über Änderung benachrichtigen
  ///default -false
  get suchbuttonNotifier;

     ///Dient der Anpassung der Liste in [EinkaufslisteNotifier] über die Benutzeroberfläche
     /// Der Parameter [dazu]  steuert, ob die Menge des angegebenen Elements
  /// erhöht oder verringert werden soll
  /// Prüft anhand von [name] ob Zutat bereits in Liste liegt und aktualisiert die Liste entsprechend
   ///ist [dazu] false und die Zutat nicht in der Liste vorhanden, wird die Liste nicht aktualisiert
     void einkaufsListeAnpassen(String name, String menge, String einheit, bool dazu);

     ///Löscht den Eintrag an der [index]-ten Stelle der Liste  [EinkaufslisteNotifier]
     void loeschen(int index);


     ///Übernimmt die Änderungen an der Einkaufsliste in die Datenbank
    void speichern();


    ///Durchsucht die Einkaufsliste nach Elementen die [zutat] im Namen enthalten ,
  ///legt die passenden Zutaten in [SuchlisteNotifier] ab und benachrichtigt damit Listener über Änderungen der Liste
  ///setzt [suchbuttonNotifier] auf true
     void suchen(String zutat);


     ///Löscht die Zutat an der [index]-ten Stelle von [EinkaufslisteNotifier] und speichert sie in
  ///der Datenbank in die Vorratskammer ein, falls "Vorratskammer verwenden" in den Settings gesetzt wurde
     void abhaken(int index);



}