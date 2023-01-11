import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/GekochtesRezeptGrenzklasse.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/PlaeneRezeptAnzeigenController.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/WochenplanController.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import '../../Fachlogik/service_locator.dart';
import 'PlaeneRezeptAnzeigen.dart';

class WidgetTableCalendar extends StatefulWidget {
  WidgetTableCalendar({Key? key}) : super(key: key);

  final WochenplanController wochenplanManager = getIt<WochenplanController>();
  final stateManager2 = getIt<PlaeneRezeptAnzeigenController>();
  String suchtitel ="";
  List<String> suchkategorie=[];
  List<String> suchAusschlussKategorien=[];

  @override
  _WidgetTableCalendarState createState() => _WidgetTableCalendarState();
}

class _WidgetTableCalendarState extends State<WidgetTableCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late final ValueNotifier<List<String>> _selectedEvents;

  List<int> aktuellerTagGekochtesRezeptIds=[];

  List<GekochtesRezeptGrenzklasse> testRezepte=[
    GekochtesRezeptGrenzklasse(gekochtesRezept_ID: 11, rezept_id: 1, datum: DateTime(2023, 1, 8, 14, 30), abgeschlossen: true, naehrwert_id: 11, status: 1, portion: 1)
  ];

  // Get all IDs that are in the wochenplan
  List<String> _getEventsForDay(DateTime day) {
    // Implementation example
    List<String> rezepte = [];
    aktuellerTagGekochtesRezeptIds=[];
    for (int i = 0; i < widget.wochenplanManager.WochenplanNotifier.value.length; i++) {
      if (widget.wochenplanManager.WochenplanNotifier.value[i].datum.year == day.year &&
          widget.wochenplanManager.WochenplanNotifier.value[i].datum.month == day.month &&
          widget.wochenplanManager.WochenplanNotifier.value[i].datum.day == day.day) {
        rezepte.add(widget.wochenplanManager.WochenplanNotifier.value[i].gekochtesRezept_ID
            .toString());
        aktuellerTagGekochtesRezeptIds.add(widget.wochenplanManager.WochenplanNotifier.value[i].rezept_id);

      }
      //if (isSameDay(day, widget.wochenplanManager.WochenplanNotifier.value[i].datum)){
      //  print("object");
      //}
    }
    return rezepte;
  }

  // init-method
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!)); // get all Events
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 200,
            // Calendar
            child:
        ValueListenableBuilder<List<GekochtesRezeptGrenzklasse>>(
        valueListenable: widget.wochenplanManager.WochenplanNotifier,
        builder: (context, value, _) {

      return
        TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2050),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _selectedEvents.value = (_getEventsForDay(_selectedDay!)); // Show Events when clicked
                  });
                }
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;}
                );
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            );})),

        const SizedBox(height: 8.0),
        SizedBox(
          height: 150,
          child: ValueListenableBuilder<List<String>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric( horizontal: 12.0,  vertical: 4.0, ),
                    decoration: BoxDecoration( border: Border.all(), borderRadius: BorderRadius.circular(12.0), ),
                    child: ListTile(


                      // auf Rezept ansehen umleiten
                      onTap: () async{
                        await
                        widget.stateManager2.RezeptHolen(int.parse(value[index]));

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlaeneRezeptAnzeigen())
                      );},
                      //onTap: () => print('${value[index]}'),
                      title: Row (
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children:[
                          Image.asset('assets/images/DefaultRezept.jpg', height: 50,),
                          Text('${value[index]}'),
                          //Container(width: 10),
                          Flexible(
                              child: Container(
                                padding: new EdgeInsets.only(left: 13.0),
                                child: Text(
                                  'Nudeln mit Tomaten-Soße',
                                  //overflow: TextOverflow.ellipsis, // Name wird abgeschnitten
                                ),
                              ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('${DateFormat.jm().format(testRezepte[0].datum)}'),
                            ),
                          ),

                          //widget.stateManager2.RezeptHolen(rezeptid)

                          //Text('${widget.stateManager2.titelGeben()}'),
                          // Wie finde ich das richtige Rezept zu value[index]
                          // Und warum sind in value nur Strings abgespeichert, keine Rezepte
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
