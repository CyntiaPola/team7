import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/WochenplanController.dart';

import '../../Fachlogik/service_locator.dart';
import 'WidgetTableCalendar.dart';

class PlaeneHome extends StatelessWidget {
  PlaeneHome({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('Wochenplan'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          /// Widgets
          WidgetTableCalendar(),
          const WidgetTextButton(),
          Text('Durchschnittswerte der letzten 7 Tage:'),
          DataTable(
            headingRowHeight: 0,
            dataRowHeight: 20,
            columns: const [
              DataColumn(label: Text('Nährwerte')),
              DataColumn(label: Text('Werte')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('kcal')),
                DataCell(Text('Row 1, Column 2')),
              ]),
              DataRow(cells: [
                DataCell(Text('Fett')),
                DataCell(Text('Row 2, Column 2')),
              ]),
              DataRow(cells: [
                DataCell(Text('gesättigte Fettsäuren')),
                DataCell(Text('Row 4, Column 2')),
              ]),
              DataRow(cells: [
                DataCell(Text('Zucker')),
                DataCell(Text('Row 5, Column 2')),
              ]),
              DataRow(cells: [
                DataCell(Text('Eiweiß')),
                DataCell(Text('Row 6, Column 2')),
              ]),
              DataRow(cells: [
                DataCell(Text('Salz')),
                DataCell(Text('Row 6, Column 2')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class WidgetTextButton extends StatelessWidget {
  const WidgetTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            getIt<WochenplanController>().suchen();
          },
          child: const Text("Neues Rezept einfügen")
      ),
    );
  }
}
