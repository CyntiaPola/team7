import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/VorratskammerController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Vorratskammerinhalt_Anzeige.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

class VorratScreen extends StatefulWidget {
  final statemanager = getIt<VorratskammerController>();

  @override
  _VorratScreenState createState() => _VorratScreenState();
}

class _VorratScreenState extends State<VorratScreen> {
  ValueNotifier<bool> enableSpeichern = ValueNotifier(false);

  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  void initState() {
    // widget.statemanager.init();
    widget.statemanager.gibVorratskammer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vorratskammer")),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        //alignment: Alignment.center,
        //constraints: BoxConstraints.tightFor(),
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 40,
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                color: Color.fromARGB(204, 255, 255, 255),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                      },
                    ),
                    hintText: 'Gesuchte Zutat',
                    border: InputBorder.none),
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ValueListenableBuilder(
                    valueListenable: widget.statemanager.VorratskammerNotifier,
                    child: _getDatatable(),
                    builder: (context, n, c) {
                      return _getDatatable();
                    },
                  ))),
          ValueListenableBuilder(
            valueListenable: enableSpeichern,
            child: _getDrawer(),
            builder: (context, n, c) {
              return _getDrawer();
            },
          )
        ]),
      ),
    );
  }

  Container _getDrawer() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 40),
              child: ElevatedButton.icon(
                onPressed: () {
                  aDialog(context, "", 0, "g", 0, 0);
                },
                icon: Icon(Icons.add, size: 30),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 76, 175, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                label: Text("Zutat"),
              )),
          Spacer(),
          ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 40),
              child: ElevatedButton.icon(
                onPressed: enableSpeichern.value
                    ? () {
                        widget.statemanager.speichern();
                        enableSpeichern.value = false;
                      }
                    : null,
                icon: Icon(Icons.storage, size: 27),
                style: ElevatedButton.styleFrom(
                  backgroundColor: enableSpeichern.value
                      ? Color.fromARGB(255, 76, 172, 175)
                      : Color.fromARGB(255, 161, 199, 201),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                label: Text("Änderungen speichern"),
              )),
        ],
      ),
    );
  }

  String cutName(String s) {
    String newStr = "";
    for (int i = 0; i < s.length; i++) {
      newStr += s[i];
      if (i % 13 == 0 && i > 0) newStr += "-\n";
    }
    return newStr;
  }

  _getDatatable() {
    return DataTable(
        sortAscending: _isAscending,
        sortColumnIndex: _currentSortColumn,
        columnSpacing: 0,
        //dataRowHeight: 40,
        columns: [
          DataColumn(label: Text(' ')),
          DataColumn(
            label: Text('Name'),
            onSort: (columnIndex, _) {
              _currentSortColumn = columnIndex;
              if (_isAscending) {
                _isAscending = false;
                widget.statemanager.sort(0);
              } else {
                _isAscending = true;
                widget.statemanager.sort(1);
              }
            },
          ),
          DataColumn(label: Text('Menge   ')),
          DataColumn(label: Text('Einheit')),
          DataColumn(label: Text(' '))
        ],
        rows: mapToRow());
  }

  List<DataRow> mapToRow() {
    List<DataRow> rowList = [];
    for (int i = 0;
        i < widget.statemanager.VorratskammerNotifier.value.length;
        i++) {
      rowList.add(DataRow(cells: [
        DataCell(IconButton(
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 45),
          //alignment: Alignment.centerLeft,
          icon: Icon(Icons.edit),
          iconSize: 20,
          onPressed: () {
            aDialog(
                context,
                widget.statemanager.VorratskammerNotifier.value[i].name,
                widget.statemanager.VorratskammerNotifier.value[i].menge,
                widget.statemanager.VorratskammerNotifier.value[i].einheit,
                1,
                widget.statemanager.VorratskammerNotifier.value[i]
                    .vorratskammer_id);
          },
          color: Color.fromARGB(255, 76, 175, 80),
        )),
        DataCell(Text(
            /* "${widget.statemanager.VorratskammerNotifier.value[i].vorratskammer_id}" +
                ' ' + */
            (widget.statemanager.VorratskammerNotifier.value[i].name.length > 15
                ? cutName(
                    widget.statemanager.VorratskammerNotifier.value[i].name)
                : widget.statemanager.VorratskammerNotifier.value[i]
                    .name) /* +
                "${widget.statemanager.VorratskammerNotifier.value[i].zutatsname_id}" +
                ' '*/
            )),
        DataCell(
          Align(
              alignment: Alignment.centerRight,
              child: Text(' ' +
                  "${widget.statemanager.VorratskammerNotifier.value[i].menge}")),
        ),
        DataCell(Text(
            "  " + widget.statemanager.VorratskammerNotifier.value[i].einheit)),
        DataCell(IconButton(
          alignment: Alignment.centerRight,
          // constraints:
          //     BoxConstraints(maxHeight: 30, maxWidth: 10),
          icon: Icon(Icons.remove_circle_outline),
          iconSize: 20,
          onPressed: () {
            widget.statemanager.loeschen(widget
                .statemanager.VorratskammerNotifier.value[i].vorratskammer_id);
            enableSpeichern.value = true;
          },
          color: Color.fromRGBO(244, 67, 54, 1),
        )),
      ]));
    }
    return rowList;
  }

  aDialog(BuildContext context, String nameInit, int mengeInit,
      String einheitInit, int version, int vkid) {
    String zutatName = nameInit;
    var zutatEinheit = einheitInit;
    //var nameController = TextEditingController();
    var mengeController = TextEditingController(text: "$mengeInit");

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: Container(
              height: 240,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 15, left: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name:",
                        //selectionColor: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 1, right: 15, left: 15),
                      child: Autocomplete<String>(
                        initialValue: TextEditingValue(text: nameInit),
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '')
                            return const Iterable<String>.empty();
                          return widget.statemanager
                              .getList()
                              .where((String element) {
                            return element.contains(textEditingValue.text);
                          });
                        },
                        onSelected: (String name) {
                          zutatName = name;
                        },
                      )),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 15, left: 15),
                      child: Row(
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 50, maxWidth: 150),
                            child: TextFormField(
                              controller: mengeController,
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Menge',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 60, maxWidth: 70),
                            child: DropdownButtonFormField(
                              items: [
                                DropdownMenuItem(child: Text("g"), value: "g"),
                                DropdownMenuItem(
                                    child: Text("ml"), value: "ml"),
                                DropdownMenuItem(
                                    child: Text("Stück"), value: "Stück"),
                                DropdownMenuItem(
                                    child: Text("Prise"), value: "Prise")
                              ],
                              value: zutatEinheit,
                              onChanged: (value) {
                                if (value is String) zutatEinheit = value;
                              },
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (version == 0) {
                        if (widget.statemanager.erzeugen(
                                zutatName,
                                int.parse(mengeController.text),
                                zutatEinheit) ==
                            1) {
                          print("Eins..");
                        } else {
                          enableSpeichern.value = true;
                          Navigator.of(context).pop();
                        }
                      } else {
                        if (widget.statemanager.aktualisieren(
                                vkid,
                                zutatName,
                                int.parse(mengeController.text),
                                zutatEinheit) ==
                            1) {
                          print("Eins..");
                        } else {
                          enableSpeichern.value = true;
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child:
                        version == 0 ? Text('hinzufügen') : Text('übernehmen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 76, 175, 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )
                ],
              ),
            ))));
  }

  // List<String> einheiten = ["g", "ml", "Stück", "Prise"];
}
