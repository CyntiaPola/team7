import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Schritte_Rezeptanzeige.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/WochenplanController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Zutat_Rezeptanzeige.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../Fachlogik/SteuerungsAPI/PlaeneRezeptAnzeigenController.dart';

class PlaeneRezeptAnzeigen extends StatefulWidget {
  final stateManager = getIt<PlaeneRezeptAnzeigenController>();
  final wochenplanManager= getIt<WochenplanController>();


  @override
  PlaeneRezeptAnzeigenState createState() => PlaeneRezeptAnzeigenState();
}

class PlaeneRezeptAnzeigenState extends State<PlaeneRezeptAnzeigen> {
  late TextEditingController _portionenController;

  var schrittliste;

  @override
  void initState() {
    _portionenController = new TextEditingController();
    widget.stateManager.aktuellPortionZurueckSetzen();
    schrittliste = widget.stateManager.schritteGeben();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[200],
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(widget.stateManager.titelGeben()),
            actions: [ settings()],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            SizedBox(
                width: (MediaQuery.of(context).size.width - 20) / 2,
                height: 150,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      Text(
                          " Dauer:       ${widget.stateManager.dauerGeben()}min",
                          style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20, width: 20),
                      Row(children: [
                        Text(" Anspruch: ",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Icon(
                          Icons.star,
                          color: widget.stateManager.anspruchGeben()[0],
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: widget.stateManager.anspruchGeben()[1],
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: widget.stateManager.anspruchGeben()[2],
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: widget.stateManager.anspruchGeben()[3],
                          size: 14,
                        ),
                        Icon(
                          Icons.star,
                          color: widget.stateManager.anspruchGeben()[4],
                          size: 14,
                        )
                      ]),
                      SizedBox(height: 20, width: 20),
                      Row(children: [
                        Text(" Portionen: ", style: TextStyle(fontSize: 20)),
                        SizedBox(
                            width: 60,
                            height: 30,
                            child: TextFormField(
                              onChanged: (text) => {
                                if (text.contains(RegExp("[^0123456789.]")))
                                  {_portionenController.text = "1"}
                                else
                                  {
                                    if (text != "")
                                      {
                                        setState(() {
                                          widget.stateManager.portionAnpassen(
                                              double.parse(text));
                                        })
                                      }
                                  }
                              },
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                              controller: _portionenController,
                            ))
                      ]),
                    ])),
            SizedBox(width: 10),
            SizedBox(
                width: (MediaQuery.of(context).size.width - 20) / 2,
                child: InkWell(
                  onTap: () {},
                  child: Image(
                      image: FileImage(File(widget.stateManager.bildGeben()))),
                )),
            SizedBox(width: 10),
          ]),
          _zutatenliste(widget.stateManager.zutatenGeben()),
          SizedBox(height: 10),
              _naehrwertliste(),
              SizedBox(height: 10),
          _schrittliste(schrittliste),


                  widget.stateManager.gekochtesRezept.abgeschlossen ? Container()
                  : ElevatedButton(
                  onPressed: () async {

                    Navigator.of(context).pop();
                    widget.stateManager.kochen();
                  },
                  child: Text("Kochen", style: TextStyle(fontSize: 20)))
          ],
          ),
      ),
    );
  }

  Widget _zutatenliste(List<Zutat_Rezeptanzeige> list) {
    if (list.isEmpty)
      return Builder(builder: (context) {
        return ListTile(title: Text("Zutaten"));
      });
    return ExpansionTile(
        title: Text(
          "Zutaten",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 6.0, top: 0, right: 6.0, bottom: 0),
            child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text("Menge"),
                  ),
                  DataColumn(
                    label: Text("Zutat"),
                  ),
                  DataColumn(
                    label: Text(""),
                  ),
                ],
                rows: widget.stateManager
                    .zutatenGeben()
                    .map(
                      (zutat) => DataRow(
                        cells: [
                          DataCell(
                            Text('${zutat.menge}${zutat.einheit}'),
                          ),
                          DataCell(
                            Text('${zutat.name}'),
                          ),
                          DataCell(
                            Text(''),
                          ),
                        ],
                      ),
                    )
                    .toList()),
          ),
        ]);
  }

  Widget _naehrwertliste() {
    return widget.stateManager.naehrwerteAnzeigen
        ? ExpansionTile(
            title: Text(
              "Nährwerte",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 6.0, top: 0, right: 6.0, bottom: 0),
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 6.0, top: 0, right: 6.0, bottom: 0),
                      child: Table(border: TableBorder.all(), children: [
                        TableRow(children: [
                          Column(children: [Text('')]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [Text("pro Portion")]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [Text('gesamt')]),
                        ]),
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('Energie')]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${widget.stateManager.naehrwertNotifier.value.kcal / widget.stateManager.portionGeben()} kcal")
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${widget.stateManager.naehrwertNotifier.value.kcal} kcal')
                              ]),
                        ]),
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('Fett')]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${widget.stateManager.naehrwertNotifier.value.fat / widget.stateManager.portionGeben()} g")
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${widget.stateManager.naehrwertNotifier.value.fat} g')
                              ]),
                        ]),
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('davon gesättigte Fettsäuren')]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${widget.stateManager.naehrwertNotifier.value.saturatedFat / widget.stateManager.portionGeben()} g")
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${widget.stateManager.naehrwertNotifier.value.saturatedFat}  g')
                              ]),
                        ]),
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('Zucker')]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${widget.stateManager.naehrwertNotifier.value.sugar / widget.stateManager.portionGeben()} g")
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${widget.stateManager.naehrwertNotifier.value.sugar} g')
                              ]),
                        ]),
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('Eiweiß')]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${widget.stateManager.naehrwertNotifier.value.protein / widget.stateManager.portionGeben()} g")
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${widget.stateManager.naehrwertNotifier.value.protein} g')
                              ]),
                        ]),
                        TableRow(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('Salz')]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${widget.stateManager.naehrwertNotifier.value.sodium / widget.stateManager.portionGeben()} mg")
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${widget.stateManager.naehrwertNotifier.value.sodium}  mg')
                              ]),
                        ]),
                      ])),
                ),
              ])
        : Container();
  }

  Widget _schrittliste(List<Schritte_Rezeptanzeige> list) {
    List<Widget> widgetSchrittList = [];
    for (Schritte_Rezeptanzeige schritt in list) {
      String zusatzangabe = "";
      if (schritt.zusatzwert != -1) {
        zusatzangabe =
            "(" + schritt.zusatzwert.toString() + schritt.zusatz + ")";
      }
      widgetSchrittList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Text("${schritt.schrittid})  ${schritt.anweisung}  $zusatzangabe"),
          ],
        ),
      ));
    }

    return ExpansionTile(
        title: Text(
          "Zubereitung",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(left: 6.0, top: 0, right: 6.0, bottom: 0),
              child: Column(children: widgetSchrittList)),
        ]);
  }


  Widget settings() {
    return PopupMenuButton(
      icon: Icon(Icons.settings),
      color: Colors.green,
      onSelected: (newValue) {


        if (newValue == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AlertDialog(
                    title: Text('Geplantes Rezept löschen'),
                    content: Text('Geplantes Rezept wirklich löschen?'),
                    actions: <Widget>[
                      TextButton(
                          child: Text('Abbrechen'),
                          onPressed: () {
                            // Hier passiert etwas
                            Navigator.of(context).pop();
                          }),
                      TextButton(
                        child: Text('Bestätigen'),
                        onPressed: () async {


                          await widget.stateManager.loeschen();
                          await widget.wochenplanManager.gibWochenplan();


                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )));
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Löschen"),
          value: 0,
        ),
      ],
    );
  }
}
