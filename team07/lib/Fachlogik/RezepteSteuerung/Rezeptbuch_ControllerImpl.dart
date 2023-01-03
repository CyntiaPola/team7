import 'package:flutter/cupertino.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorie.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezept.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Datenhaltung/DatenhaltungsAPI/ICRUDkategorieRezeptZuordnung.dart';



class Rezeptbuch_ControllerImpl extends ChangeNotifier implements Rezeptbuch_Controller {

  ///Speichert, ob Suchbutton in Rezeptsuche gedrückt wurde
  final suchButtonNotifier = ValueNotifier<bool>(false);

  ///Speichert in Filter angegebene Kategorien und Zutaten als Liste
  final kategorieZutatenNotifier = ValueNotifier<List<String>>([]);

  ///Speichert auszuschließende Zutaten als Liste
  final kategorieZutatenAusschlussNotifier=ValueNotifier<List<String>>([]);

  ///Speichert Liste nach Titel und/oder Zutaten/Kategorien gefilterte RezepteGUI
  final rezeptListeNotifier = ValueNotifier<List<Rezept>>([]);

  ///Speichert Liste von Rezeptvorschlägen
  final rezeptVorschlaegeNotifier = ValueNotifier<List<Rezept>>([]);


  ///Zugriffspunkt auf RezepteGUI in Datenbank
  ICRUDRezept rezeptSchnittstelle = getIt<ICRUDRezept>();

  ///Zugriffspunkt auf Kategorien in Datenbank
  ICRUDkategorie kategorieSchnittstelle = getIt<ICRUDkategorie>();

  ///Zugriffspunkt auf KategorieRezeptZuordnungen in Datenbank
  ICRUDkategorieRezeptZuordnung kategorieRezeptZuordnungSchnittstelle = getIt<
      ICRUDkategorieRezeptZuordnung>();

  ///Zugriffspunkt auf Zutaten in Datenbank;
  ICRUDzutaten zutatenSchnittstelle = getIt<ICRUDzutaten>();

  ///Zugriffspunkt auf Zutatsnamen in Datenbank;
  ICRUDzutaten_Name zutatenNameSchnittstelle = getIt<ICRUDzutaten_Name>();





  ///Setzt den Wert, ob der Suchbutton gerückt wurde zurück auf false und leert die Liste an gefilterten Kategorien und Zutaten
  ///Wird benutzt um nach Suche wieder auf den Suchbildschirm mit den Rezeptvorschlägen zu kommen
  @override
  void stoebernWiederherstellen() {
    suchButtonNotifier.value = false;
    List<String> list = [];
    List<String> list2 = [];
    kategorieZutatenNotifier.value = list;
    kategorieZutatenAusschlussNotifier.value =list2;
  }

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
  @override
  Future<void> suchen(String titel, List<String> kategorie, List<String> ausgeschlosseneZutaten) async {
    suchButtonNotifier.value = true;

    var alleRezepte = await rezeptSchnittstelle.getRezeptTitel(titel);


    List<String> bearbeitbareKategorie=[];
    for(int i=0; i<kategorie.length; i++){
      bearbeitbareKategorie.add(kategorie[i]);
    }

    List<String> bearbeitbareAusgeschlosseneZutaten=[];
    for(int i=0; i<ausgeschlosseneZutaten.length; i++){
      bearbeitbareAusgeschlosseneZutaten.add(ausgeschlosseneZutaten[i]);
    }


    List<Rezept> neueListe = [];

    if(bearbeitbareKategorie.isNotEmpty || bearbeitbareAusgeschlosseneZutaten.isNotEmpty) {
      

      List<int> zutatenIds = [];
      List<int> ausgeschlosseneZutatenIds = [];

      for(int i=0; i< bearbeitbareAusgeschlosseneZutaten.length; i++){
        int id= await zutatenNameSchnittstelle.getZutatenNameId(bearbeitbareAusgeschlosseneZutaten[i]);
        if(id!=-1){
          ausgeschlosseneZutatenIds.add(id);
        }
      }

      for (int i = bearbeitbareKategorie.length-1; i >= 0; i--) {
        int id = await zutatenNameSchnittstelle.getZutatenNameId(bearbeitbareKategorie[i]);
        if(id!=-1) {
          zutatenIds.add(id);
          bearbeitbareKategorie.removeAt(i);
        }
      }


      List<int> kategorieIds = [];
      for (int i = 0; i < bearbeitbareKategorie.length; i++) {
        int id = await kategorieSchnittstelle.getKategorieIdByName(
            bearbeitbareKategorie[i]);
        if(id!=-1) {
          kategorieIds.add(id);
        }
      }


      List<int> alleRezeptIds = [];
      for (int i = 0; i < alleRezepte.length; i++) {
        alleRezeptIds.add(alleRezepte
            .elementAt(i)
            .rezept_id);
      }




      List<int> passendeRezeptIds = [];
      for (int i = 0; i < alleRezeptIds.length; i++) {
        bool allesVorhanden =true;
       var kategorieZuordnungenProRezept = await kategorieRezeptZuordnungSchnittstelle.getKategorieRezeptZuordnungByRezeptID(alleRezeptIds[i]);
       var kategorieZuordnungenProRezeptKategorieIds=[];
       for(int j=0; j< kategorieZuordnungenProRezept.length; j++){
         kategorieZuordnungenProRezeptKategorieIds.add(kategorieZuordnungenProRezept.elementAt(j).kategorie_id);
       }
        for(int j=0; j< kategorieIds.length;j++){
          if(kategorieZuordnungenProRezeptKategorieIds.contains(kategorieIds[j])==false){
            allesVorhanden=false;
            break;
          }
        }

        if(allesVorhanden){
          var rezeptzutaten = await zutatenSchnittstelle.getRezeptZutaten(
              alleRezepte
                  .elementAt(i)
                  .rezept_id);
          var rezeptzutatenIds=[];
          for(int j=0; j< rezeptzutaten.length; j++){
            rezeptzutatenIds.add(rezeptzutaten.elementAt(j)
                .name_id);
          }
          for(int j=0; j< ausgeschlosseneZutatenIds.length;j++){
            if(rezeptzutatenIds.contains(ausgeschlosseneZutatenIds[j])){
              allesVorhanden=false;
              break;
            }
          }

          for(int j=0; j< zutatenIds.length; j++){
            if(rezeptzutatenIds.contains(zutatenIds[j])==false){

              allesVorhanden=false;
              break;

            }
          }


        }

        if(allesVorhanden){
          passendeRezeptIds.add(alleRezeptIds[i]);
        }
      }



      for (int i = 0; i < alleRezepte.length; i++) {
        if (passendeRezeptIds.contains(alleRezepte
            .elementAt(i)
            .rezept_id)) {
          neueListe.add(Rezept(titel: alleRezepte
              .elementAt(i)
              .titel,
              dauer: alleRezepte
                  .elementAt(i)
                  .dauer
                  .toString(),
              bild: alleRezepte
                  .elementAt(i)
                  .bild,
              anspruch: alleRezepte
                  .elementAt(i)
                  .anspruch,
              id: alleRezepte
                  .elementAt(i)
                  .rezept_id))
          ;
        }
      }
    }
    else{
      for (int i = 0; i < alleRezepte.length; i++) {
          neueListe.add(Rezept(titel: alleRezepte
              .elementAt(i)
              .titel,
              dauer: alleRezepte
                  .elementAt(i)
                  .dauer
                  .toString(),
              bild: alleRezepte
                  .elementAt(i)
                  .bild,
              anspruch: alleRezepte
                  .elementAt(i)
                  .anspruch,
              id: alleRezepte
                  .elementAt(i)
                  .rezept_id))
          ;

      }
    }

      rezeptListeNotifier.value = neueListe;
    }



    ///Fügt der Liste der zum Filtern eingegebenen Kategorien/Zutaten [kategorieZutat] hinzu und informiert so Listener über Änderung der Liste
  ///
  /// ///Löscht eventuell bereits vorhandene gleichnamige Eintragungen, um Dopplungen zu vermeiden
    void kategorieZutatFiltern(String kategorieZutat) {
        kategorieZutatLoeschen(kategorieZutat);

      List<String> list = [];
      for (String s in kategorieZutatenNotifier.value) {
        list.add(s);
      }
      list.add(kategorieZutat);

      kategorieZutatenNotifier.value = list;
    }


  ///Fügt der Liste der ausgeschlossenen Zutaten [kategorieZutat] hinzu und informiert so Listener über Änderung der Liste
  ///
  ///Löscht eventuell bereits vorhandene gleichnamige Eintragungen, um Dopplungen zu vermeiden
  void kategorieZutatAusschliessen(String kategorieZutat) {

      kategorieZutatLoeschen(kategorieZutat);

    List<String> list = [];
    for (String s in kategorieZutatenAusschlussNotifier.value) {
      list.add(s);
    }
    list.add(kategorieZutat);


    kategorieZutatenAusschlussNotifier.value = list;
  }

    ///gibt die Liste der Zutaten und Kategorien nach denen gefiltert werden soll zurück
    List<String> gibGewaehlteKategorien() {
      return kategorieZutatenNotifier.value;
    }

  ///gibt die Liste der ausgeschlossenen Zutaten zurück
  List<String> gibAusgeschlosseneZutaten() {
    return kategorieZutatenAusschlussNotifier.value;
  }



    ///Löscht ein Element aus der Liste der Zutaten/Kategorien nach denen gefiltert werden soll
    void kategorieZutatLoeschen(String kategorieZutat) {
      List<String> list = [];
      for (String s in kategorieZutatenNotifier.value) {
        list.add(s);
      };
      list.remove(kategorieZutat);

      kategorieZutatenNotifier.value = list;

      List<String> list2 = [];
      for (String s in kategorieZutatenAusschlussNotifier.value) {
        list2.add(s);
      };
      list2.remove(kategorieZutat);

      kategorieZutatenAusschlussNotifier.value = list2;
    }


    ///Gibt alle Kategorien die in der Datenbank sind zurück
    Future<List<String>> gibAlleKategorien() async {
      List<String> ausgabe = [];
      var kategorien = await kategorieSchnittstelle.getKategorien();

      for (int i = 0; i < kategorien.length; i++) {
        ausgabe.add(kategorien
            .elementAt(i)
            .kategorie);
      }
      return ausgabe;
    }



    ///Speichert alle RezepteGUI die in der Datenbank sind, zufällig gemischt in der Liste der Rezeptvorschläge und informiert  so Listener, dass sich Liste geändert hat
    Future<void> gibAlleRezepte() async {
      List<Rezept> neueListe = [];
      var alleRezepte = await rezeptSchnittstelle.getRezepte();

      for (int i = 0; i < alleRezepte.length; i++) {
        neueListe.add(Rezept(titel: alleRezepte
            .elementAt(i)
            .titel,
            dauer: alleRezepte
                .elementAt(i)
                .dauer
                .toString(),
            bild: alleRezepte
                .elementAt(i)
                .bild,
            anspruch: alleRezepte
                .elementAt(i)
                .anspruch,
            id: alleRezepte
                .elementAt(i)
                .rezept_id))
        ;
      }
      neueListe.shuffle();
      rezeptVorschlaegeNotifier.value = neueListe;
    }
  }

