import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDRezept.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDkategorie.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDnaehrwerte_pro_100g.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDschritt.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutaten_Name.dart';
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/ICRUDzutats_Menge.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';
import '../../Datenhaltung/DatenhaltungsAPI/ICRUDkategorieRezeptZuordnung.dart';
import '../SteuerungsAPI/RezeptAnlegenController.dart';
import '../SteuerungsAPI/Rezeptschritt.dart';
import 'package:http/http.dart' as http;


class RezeptAnlegenControllerImpl implements RezeptAnlegenController {


  ///Zugriffspunkt auf RezepteGUI in Datenbank
  ICRUDRezept rezeptSchnittstelle = getIt<ICRUDRezept>();
  ///Zugriffspunkt auf Schritte in Datenbank
  ICRUDschritt schrittSchnittstelle = getIt<ICRUDschritt>();
  ///Zugriffspunkt auf Zutaten in Datenbank
  ICRUDzutaten zutatenSchnittstelle = getIt<ICRUDzutaten>();
  ///Zugriffspunkt auf Zutatennamen in Datenbank
  ICRUDzutaten_Name zutatennameSchnittstelle = getIt<ICRUDzutaten_Name>();
  ///Zugriffspunkt auf schrittspezifische Zutaten in Datenbank
  ICRUDzutats_Menge schrittzutatenSchnittstelle = getIt<ICRUDzutats_Menge>();
  ///Zugriffspunkt auf Kategorien in Datenbank
  ICRUDkategorie kategorieSchnittstelle = getIt<ICRUDkategorie>();
  ///Zugriffspunkt auf Kategoriezuordnungen in Datenbank
  ICRUDkategorieRezeptZuordnung kategorieRezeptZuordnungSchnittstelle = getIt<ICRUDkategorieRezeptZuordnung>();

  ///Zugriffspunkt auf die Steuerungskomponente der Rezeptsuche
  Rezeptbuch_Controller rezeptbuch_controller = getIt<Rezeptbuch_Controller>();
  RezeptAnzeigenController rezeptAnzeigenController = getIt<RezeptAnzeigenController>();


  ///Zugriffspunkt auf die Naehrwertangaben in der Datenbank
  ICRUDnaehrwerte_pro_100g naehrwerteSchnittstelle = getIt<ICRUDnaehrwerte_pro_100g>();


  ///Speichert Anspruch als Farbarray der Länge 5 mit dem Anspruch entsprechend oft gelb und dann schwarz
  @override
  final anspruchNotifier = ValueNotifier<List<Color>>(
      [Colors.black, Colors.black, Colors.black, Colors.black, Colors.black]);

  ///speichert Zutaten als Liste von Objekten mit Name, Menge, Einheit einer Zutat
  @override
  final zutatenNotifier = ValueNotifier<List<Zutat>>(
      [Zutat(name: "", menge: "", einheit: "")]);


  ///Speichert Rezeptschritte als Liste von Objekten mit Name, Menge, Einheit, Dauer und der Info ob ein Timer- oder Wiegeschritt vorliegt
  @override
  final schrittNotifier = ValueNotifier<List<Rezeptschritt>>([
    Rezeptschritt(schritt: "",
        zutat: "",
        menge: "",
        einheit: "",
        zeit: "",
        timerschritt: false,
        wiegeschritt: false),
    Rezeptschritt(schritt: "",
        zutat: "",
        menge: "",
        einheit: "",
        zeit: "",
        timerschritt: false,
        wiegeschritt: false)
  ]);


  ///Speichert eine Liste von Kategorien als Strings
  @override
  var kategorieNotifier = ValueNotifier<List<String>>([]);


  List<String> rezeptzutatennamen = [];
  List<String> zutatennamen = [];
  String titel = "";
  String dauer = "";
  String portion = "";


  ///Speichert den Pfad eines Bildes als String
  final bildNotifier = ValueNotifier<String>("");


  ///Setzt alle Attribute dieser Klasse auf ihren Default-Wert
  void zuruecksetzen(){
     titel = "";
     dauer = "";
     portion = "";
    bildNotifier.value="";
    kategorieNotifier = ValueNotifier<List<String>>([]);
    schrittNotifier.value = [
      Rezeptschritt(schritt: "",
          zutat: "",
          menge: "",
          einheit: "",
          zeit: "",
          timerschritt: false,
          wiegeschritt: false),
      Rezeptschritt(schritt: "",
          zutat: "",
          menge: "",
          einheit: "",
          zeit: "",
          timerschritt: false,
          wiegeschritt: false)
    ];

     anspruchNotifier.value=
         [Colors.black, Colors.black, Colors.black, Colors.black, Colors.black];

     zutatenNotifier.value =
         [Zutat(name: "", menge: "", einheit: "")];



  }



  ///Speichert den [anspruch] in ein Farbarray der Länge 5 mit [anspruch]-1 gelben Werten und dem Rest schwarz und informiert Listener über Änderung
  @override
  void anspruchFestlegen(int anspruch) {

    List<Color> neueListe = [];
    for (int i = 0; i < 5; i++) {
      if (i <= anspruch) {
        neueListe.add(Colors.yellow);
      } else {
        neueListe.add(Colors.black);
      }
    }
    anspruchNotifier.value = neueListe;

  }


  ///Speichert [name], [menge], [einheit] als Zutatsobjekt in eine Liste und informiert Listener über Änderung der Liste
  @override
  void zutatHinzufuegen(String name, String menge, String einheit) {
    List<Zutat> neueListe = [];
    for (int i = 0; i < zutatenNotifier.value.length; i++) {
      neueListe.add(zutatenNotifier.value[i]);
    }
    neueListe.add(Zutat(name: name, menge: menge, einheit: einheit));

    zutatenNotifier.value = neueListe;

  }


  ///Löscht zutat an der [index] -ten Stelle der Zutatenliste und informiert Listener über Änderung
  @override
  void zutatLoeschen(int index) {
    List<Zutat> neueListe = [];
    for (int i = 0; i < zutatenNotifier.value.length; i++) {

      if (i != index) {
        neueListe.add(zutatenNotifier.value[i]);
      }
      else {

      }
    }


      zutatenNotifier.value = neueListe;

  }

  ///Speichert die übergebenen Parameter als Schritt in eine Liste und informiert Listener über Änderung der Liste
    @override
    void schrittHinzufuegen(String name, String zutat, String menge,
        String einheit, String zeit, bool wiege, bool timer) {
      List<Rezeptschritt> neueListe = [];

      for (int i = 0; i < schrittNotifier.value.length; i++) {
        neueListe.add(schrittNotifier.value[i]);
      }
      neueListe.add(Rezeptschritt(schritt: name,
          zutat: zutat,
          menge: menge,
          einheit: einheit,
          zeit: zeit,
          wiegeschritt: wiege,
          timerschritt: timer));


      schrittNotifier.value = neueListe;
    }

    /// Löscht den [indext]-ten Schritt aus der Liste und informiert Listener über Änderung der Liste
    @override
    void schrittLoeschen(int index) {
      List<Rezeptschritt> neueListe = [];
      for (int i = 0; i < schrittNotifier.value.length; i++) {
        if (i != index) {
          neueListe.add(schrittNotifier.value[i]);
        }
        else {

        }
      }
      schrittNotifier.value = neueListe;
    }


    /// Ändert die Art des [index]-ten Schritt in der Liste je nach [art] zu einem Schritt mit Zeitangabe (art=2), Mengenangabe(art=1) oder keiner zusätzlichen Angabe(art=0)
    @override
    void schrittAendern(int index, int art) {
      List<Rezeptschritt> neueListe = [];

      for (int i = 0; i < schrittNotifier.value.length; i++) {
        if (i != index) {
          neueListe.add(schrittNotifier.value[i]);

        }
        else {
          if (art == 0) {
            neueListe.add(Rezeptschritt(
                schritt: schrittNotifier.value[i].schritt,
                zutat: schrittNotifier.value[i].zutat,
                menge: schrittNotifier.value[i].menge,
                einheit: schrittNotifier.value[i].einheit,
                zeit: schrittNotifier.value[i].zeit,
                timerschritt: false,
                wiegeschritt: false));
          }
          else if (art == 1) {
            neueListe.add(Rezeptschritt(
                schritt: schrittNotifier.value[i].schritt,
                zutat: schrittNotifier.value[i].zutat,
                menge: schrittNotifier.value[i].menge,
                einheit: schrittNotifier.value[i].einheit,
                zeit: schrittNotifier.value[i].zeit,
                timerschritt: false,
                wiegeschritt: true));

          }
          else if (art == 2) {
            neueListe.add(Rezeptschritt(
                schritt: schrittNotifier.value[i].schritt,
                zutat: schrittNotifier.value[i].zutat,
                menge: schrittNotifier.value[i].menge,
                einheit: schrittNotifier.value[i].einheit,
                zeit: schrittNotifier.value[i].zeit,
                timerschritt: true,
                wiegeschritt: false));
          }
        }
      }
      schrittNotifier.value = neueListe;
    }

    ///Prüft, ob die in den Schritten angegebenen Zutaten auch im Rezept vorkommen
    @override
    bool checkRezeptZutaten() {
    zutatennamen=[];
    for(int i=0; i< schrittNotifier.value.length; i++){
      if (schrittNotifier.value[i].wiegeschritt){
        zutatennamen.add(schrittNotifier.value[i].zutat);
      }
    }
    rezeptzutatennamen=[];
    for(int i=0; i< zutatenNotifier.value.length; i++){
      rezeptzutatennamen.add(zutatenNotifier.value[i].name);
    }

      for (int i = 0; i < zutatennamen.length; i++) {
        if (rezeptzutatennamen.contains(zutatennamen[i]) == false) {
          return false;
        }
      }
      return true;
    }


    ///Speichert [kategorie] asl Kategorie in Liste ein und informiert Listener über Änderung der Liste
    @override
    void kategorieHinzufuegen(String kategorie) {
      List<String> neueListe = [];
      for (int i = 0; i < kategorieNotifier.value.length; i++) {
        neueListe.add(kategorieNotifier.value[i]);
      }
      neueListe.add(kategorie);

      kategorieNotifier.value = neueListe;
    }


    ///Löscht Kategorie an der [index]-ten Stelle der Liste und informiert Listener über Änderung der Liste
    @override
    void kategorieLoeschen(int index) {
      List<String> neueListe = [];
      for (int i = 0; i < kategorieNotifier.value.length; i++) {
        if (i != index) {
          neueListe.add(kategorieNotifier.value[i]);
        }
      }
      kategorieNotifier.value = neueListe;
    }


    ///Setzt in Controller gespeicherte Attribute des Rezepts auf Defaultwerte zurück
    resetFuerAbbrechenButton() async {
      zutatenNotifier.value = [Zutat(name: "", menge: "", einheit: "")];
      schrittNotifier.value = [
        Rezeptschritt(schritt: "",
            zutat: "",
            menge: "",
            einheit: "",
            zeit: "",
            timerschritt: false,
            wiegeschritt: false),
        Rezeptschritt(schritt: "",
            zutat: "",
            menge: "",
            einheit: "",
            zeit: "",
            timerschritt: false,
            wiegeschritt: false)
      ];
      anspruchNotifier.value =
      [Colors.black, Colors.black, Colors.black, Colors.black, Colors.black];
      int laenge = kategorieNotifier.value.length;

      for (int i = 0; i < laenge; i++) {
        kategorieLoeschen(0);
      }
      titel = "";
      dauer = "";
      portion = "";
      bildNotifier.value = "";
    }




    ///Setzt Rezepttitel auf [titel]
    void titelSetzen(String titel) {
      this.titel = titel;
    }

    ///gibt den  Titel  des Rezepts zurück
    String titelGeben() {
      return titel;
    }

    ///Setzt die Dauer des Rezepts auf [dauer]
    void dauerSetzen(String dauer) {
      this.dauer = dauer;
    }

    ///gibt die Dauer des Rezepts zurück
    String dauerGeben() {
      return dauer;
    }

    ///Setzt die Portion des Rezepts auf [portion]
    void portionSetzen(String portion) {
      this.portion = portion;
    }

    ///Gibt die Portion des Rezepts zurück
    String portionGeben() {
      return portion;
    }


    ///Holt alle Kategorien aus der Datenbank
  Future<List<String>> gibAlleKategorien() async{
    List<String> ausgabe= [];
    var kategorien= await kategorieSchnittstelle.getKategorien();

    for( int i=0; i< kategorien.length; i++){
      ausgabe.add(kategorien.elementAt(i).kategorie);

    }
    return  ausgabe;

  }


  ///Setzt den Pfad des Rezeptbilds auf in assets gespeichertes Defaultbild und informiert Listener über Änderung
    setDefaultRezeptBildAusAssets(String path) async {
      final byteData = await rootBundle.load('assets/images/$path');
      Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String filePath = '$appDocumentsPath/$path';
      final file = await File(filePath).create(recursive: true);

      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      bildNotifier.value = filePath;
    }


    /// Löst Öffnen der Gallery aus, speichert den Pfad des dort gewählten Bildes und informiert Listener über Änderung
    getFromGallery() async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        bildNotifier.value = pickedFile.path;
      }
    }


  /// Löst Öffnen der Kamera aus, speichert den Pfad des dort gemachten Bildes und informiert Listener über Änderung
  getFromCamera() async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        bildNotifier.value = pickedFile.path;
      }
    }


    ///Speichert die im Controller gespeicherten Werte zu einem Rezept in der Datenbank ab
  ///rechnet hierfür die Mengenangaben auf eine Portion herunter
    @override
    speichern()  async {
      int anspruch = 1;
      for (int i = 0; i < 5; i++) {
        if (anspruchNotifier.value[i] == Colors.yellow) {
          anspruch = i + 1;

        }
        else{
          break;
        }
      }
      int rezeptid = await rezeptSchnittstelle.setRezept(
          this.titel, int.parse(this.dauer), anspruch, bildNotifier.value);

      await rezeptbuch_controller.gibAlleRezepte();

      for (int i = 0; i < zutatenNotifier.value.length; i++) {




        bool NameSchonVorhanden= ( await zutatennameSchnittstelle.getZutatenNameId(zutatenNotifier.value[i].name)!=-1);


        double kcal=-1;
        double fat=-1;
        double saturatedFat=-1;
        double sugar=-1;

        double protein=-1;
        double sodium=-1;

        int naehrwertid=-1;
        String translatedText="";
        if(NameSchonVorhanden==false){

          String apiUrl = "https://api.mymemory.translated.net/get?q=${zutatenNotifier.value[i].name}&langpair=de|en";
          Response response= await http.get(Uri.parse(apiUrl));
          Map<String, dynamic> daten = json.decode(response.body);




          if(daten!=null){
            translatedText = daten['responseData']['translatedText'].toLowerCase();

          }

          print("übersetzung");
          print(translatedText);


          String apiKey= "WRzOZM8mCLHKzVlT/KzxCw==lrUTrAzwqmWE7pKK";
          apiUrl= "https://api.api-ninjas.com/v1/nutrition?query=$translatedText";

          Map<String, String> headers = {
            "X-Api-Key": apiKey,
          };

          response= await get(Uri.parse(apiUrl), headers:  headers);
          print(response.body);
          List <String> getrimmteResponse  = response.body.replaceAll(",", "").replaceAll('"', "").replaceAll(":", "").replaceAll("}]", "").split(" ");
          for(int j=0; j< getrimmteResponse.length; j++){
            if(getrimmteResponse[j]=="calories"){
              kcal= double.parse(getrimmteResponse[j+1]);
            }
            if(getrimmteResponse[j]=="fat_total_g"){
              fat= double.parse(getrimmteResponse[j+1]);
            }
            if(getrimmteResponse[j]=="fat_saturated_g"){
              saturatedFat= double.parse(getrimmteResponse[j+1]);
            }
            if(getrimmteResponse[j]=="protein_g"){
              protein= double.parse(getrimmteResponse[j+1]);
            }
            if(getrimmteResponse[j]=="sodium_mg"){
              sodium= double.parse(getrimmteResponse[j+1]);
            }
            if(getrimmteResponse[j]=="sugar_g"){
              sugar= double.parse(getrimmteResponse[j+1]);
            }
          }



        }

        int name_id = await zutatennameSchnittstelle.setZutatenName(
            zutatenNotifier.value[i].name, translatedText );
        if(NameSchonVorhanden==false){
          naehrwertid= await naehrwerteSchnittstelle.setNaehrwerte_pro_100g(name_id, kcal, fat, saturatedFat, sugar,  protein, sodium);

        }
        else{
          naehrwertid= await naehrwerteSchnittstelle.getNaehrwertIdByNameId(name_id);
        }

        await zutatenSchnittstelle.setZutat(
            name_id,
            rezeptid,
            naehrwertid,
            int.parse(zutatenNotifier.value[i].menge) ~/ int.parse(portion),
            zutatenNotifier.value[i].einheit,
            0,
            0,
            0,
            true); //Weiter füllen
      }

      for(int i=0; i< kategorieNotifier.value.length; i++){
         int kategorie_id= await kategorieSchnittstelle.setKategorie(
           kategorieNotifier.value[i]);
         await kategorieRezeptZuordnungSchnittstelle.setKategorieRezeptZuordnung(kategorie_id, rezeptid);


      }

      for (int i = 0; i < schrittNotifier.value.length; i++) {
        if (schrittNotifier.value[i].timerschritt) {
          await schrittSchnittstelle.setSchritt(
              i + 1, rezeptid, int.parse(schrittNotifier.value[i].zeit),
              false, schrittNotifier.value[i].schritt); // hier noch richtige Werte eintragen


        }
        else if (schrittNotifier.value[i].wiegeschritt) {
          int schrittid = await schrittSchnittstelle.setSchritt(
              i + 1, rezeptid, 0, true, schrittNotifier.value[i].schritt); // hier noch richtige Werte eintragen
          int zutatenNameid = await zutatennameSchnittstelle.setZutatenName(
              schrittNotifier.value[i].zutat, "");
          int korrespondierendeZutatId = await zutatenSchnittstelle
              .getRezeptZutatenByName(rezeptid, zutatenNameid);

          await schrittzutatenSchnittstelle.setZutatsMenge(
              rezeptid, schrittid, korrespondierendeZutatId,
              //Zutatenid noch abklären
              int.parse(schrittNotifier.value[i].menge)~/int.parse(portion),
              schrittNotifier.value[i].einheit);
        }
        else {
          await schrittSchnittstelle.setSchritt(i + 1, rezeptid, 0,
              false, schrittNotifier.value[i].schritt); // hier noch richtige Werte eintragen Nährwertid!

        }
      }
    }

  ///Speichert die im Controller gespeicherten Werte zu einem Rezept in der Datenbank ab
  ///rechnet hierfür die Mengenangaben auf eine Portion herunter
  @override
  bearbeitenSpeichern( int rezeptid)  async {
    int anspruch = 1;
    for (int i = 0; i < 5; i++) {
      if (anspruchNotifier.value[i] == Colors.yellow) {
        anspruch = i + 1;

      }
      else{
        break;
      }
    }
    rezeptSchnittstelle.updateRezept(rezeptid, this.titel, int.parse(this.dauer), anspruch, bildNotifier.value);


    await rezeptbuch_controller.gibAlleRezepte();

    zutatenSchnittstelle.deleteZutatenNachRezeptId(rezeptid);

    for (int i = 0; i < zutatenNotifier.value.length; i++) {

      bool NameSchonVorhanden= ( await zutatennameSchnittstelle.getZutatenNameId(zutatenNotifier.value[i].name)!=-1);


      double kcal=-1;
      double fat=-1;
      double saturatedFat=-1;
      double sugar=-1;

      double protein=-1;
      double sodium=-1;

      int naehrwertid=-1;
      String translatedText="";
      if(NameSchonVorhanden==false){

        String apiUrl = "https://api.mymemory.translated.net/get?q=${zutatenNotifier.value[i].name}&langpair=de|en";
        Response response= await http.get(Uri.parse(apiUrl));
        Map<String, dynamic> daten = json.decode(response.body);




        if(daten!=null){
          translatedText = daten['responseData']['translatedText'].toLowerCase();


        }

        String  apiKey= "WRzOZM8mCLHKzVlT/KzxCw==lrUTrAzwqmWE7pKK";
        apiUrl= "https://api.api-ninjas.com/v1/nutrition?query=$translatedText";

        Map<String, String> headers = {
          "X-Api-Key": apiKey,
        };

        response= await get(Uri.parse(apiUrl), headers:  headers);
        print(response.body);


        List <String> getrimmteResponse  = response.body.replaceAll(",", "").replaceAll('"', "").replaceAll(":", "").replaceAll("}]", "").split(" ");
        for(int j=0; j< getrimmteResponse.length; j++){
          if(getrimmteResponse[j]=="calories"){
            kcal= double.parse(getrimmteResponse[j+1]);


          }
          if(getrimmteResponse[j]=="fat_total_g"){
            fat= double.parse(getrimmteResponse[j+1]);

          }
          if(getrimmteResponse[j]=="fat_saturated_g"){
            saturatedFat= double.parse(getrimmteResponse[j+1]);

          }
          if(getrimmteResponse[j]=="protein_g"){
            protein= double.parse(getrimmteResponse[j+1]);

          }
          if(getrimmteResponse[j]=="sodium_mg"){
            sodium= double.parse(getrimmteResponse[j+1]);

          }
          if(getrimmteResponse[j]=="sugar_g"){
            sugar= double.parse(getrimmteResponse[j+1]);

          }
        }



      }


      int name_id = await zutatennameSchnittstelle.setZutatenName(
          zutatenNotifier.value[i].name, translatedText);

      if(NameSchonVorhanden==false){
        naehrwertid= await naehrwerteSchnittstelle.setNaehrwerte_pro_100g(name_id, kcal, fat, saturatedFat, sugar,  protein, sodium);

      }
      else{
        naehrwertid= await naehrwerteSchnittstelle.getNaehrwertIdByNameId(name_id);
      }

      await zutatenSchnittstelle.setZutat(
          name_id,
          rezeptid,
          naehrwertid,
          (int.parse(zutatenNotifier.value[i].menge) / int.parse(portion))
              .toInt(),
          zutatenNotifier.value[i].einheit,
          0,
          0,
          0,
          true); //Weiter füllen
    }


    kategorieRezeptZuordnungSchnittstelle.deleteKategorieRezeptZuordnungNachRezeptId(rezeptid);
    for(int i=0; i< kategorieNotifier.value.length; i++){
      int kategorie_id= await kategorieSchnittstelle.setKategorie(
          kategorieNotifier.value[i]);
      await kategorieRezeptZuordnungSchnittstelle.setKategorieRezeptZuordnung(kategorie_id, rezeptid);


    }

    schrittzutatenSchnittstelle.deleteZutatsMengeByRezeptId(rezeptid);
    schrittSchnittstelle.deleteSchritteNachRezeptId(rezeptid);

    for (int i = 0; i < schrittNotifier.value.length; i++) {
      if (schrittNotifier.value[i].timerschritt) {
        await schrittSchnittstelle.setSchritt(
            i + 1, rezeptid, int.parse(schrittNotifier.value[i].zeit),
            false, schrittNotifier.value[i].schritt);


      }
      else if (schrittNotifier.value[i].wiegeschritt) {
        int schrittid = await schrittSchnittstelle.setSchritt(
            i + 1, rezeptid, 0, true, schrittNotifier.value[i].schritt);
        int zutatenNameid = await zutatennameSchnittstelle.setZutatenName(
            schrittNotifier.value[i].zutat, "");
        int korrespondierendeZutatId = await zutatenSchnittstelle
            .getRezeptZutatenByName(rezeptid, zutatenNameid);

        await schrittzutatenSchnittstelle.setZutatsMenge(
            rezeptid, schrittid, korrespondierendeZutatId,
            (int.parse(schrittNotifier.value[i].menge)/int.parse(portion)).toInt(),
            schrittNotifier.value[i].einheit);
      }
      else {
        await schrittSchnittstelle.setSchritt(i + 1, rezeptid, 0,
            false, schrittNotifier.value[i].schritt);

      }
    }

    await rezeptAnzeigenController.RezeptHolen(rezeptid);
  }
  }



