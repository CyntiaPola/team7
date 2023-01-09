import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/EinkaufeGUI/components/EinkaufeItem.dart';

import '../../Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import '../../Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import '../../Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import '../../Fachlogik/SteuerungsAPI/SettingsController.dart';
import '../../Fachlogik/service_locator.dart';
import 'components/EinkaufeDialog.dart';
import 'components/EinkaufeHeader.dart';



class EinkaufeHome extends StatefulWidget {
String title = "Einkaufe";

final stateManager = getIt<Rezeptbuch_Controller>();
final settingsManager = getIt<SettingsController>();
final stateManager2 = getIt<RezeptAnzeigenController>();
final stateManagerAdden= getIt<RezeptAnlegenController>();

@override
State<EinkaufeHome> createState() => EinkaufeHomeState();

}


int AUTO_ID = 0;

class EinkaufeModel{
   String name;
   int weight;
   String unit;
   bool isChecked = false;
   int id;

   EinkaufeModel(this.id,this.name,this.weight,this.unit);

   @override
  String toString() {
    return 'EinkaufeModel{name: $name, weight: $weight, unit: $unit, isChecked: $isChecked, id: $id}';
  }
}

class EinkaufeHomeState extends State<EinkaufeHome> {
  final List<EinkaufeModel> einkaufeLists = <EinkaufeModel>[

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EinkaufeListe")),
      body:
          Container(
            margin: const EdgeInsets.all(10.0),
            child:
          Column(

            children: [

              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
                        hintText: 'Gesuchte Zutet',
                        border: InputBorder.none),
                  ),
                ),
              ),

              EinkaufeHeader(),
              Expanded(
                flex: 1,
                child:
                     ListView.builder(
                        itemCount: einkaufeLists.length,

                        itemBuilder: (BuildContext context, int index) {

                          return Align( // wrap card with Align
                             child: SizedBox(
                                width: MediaQuery.of(context).size.width ,
                                child: Card(
                                    child: EinkaufeItem(einkaufeLists[index],()=>{
                                      deleteItem(context).then((value) => {
                                        if(value!){
                                          einkaufeLists.remove(einkaufeLists[index]),
                                          setState(() { })
                                        }
                                      })


                                    })
                                )),
                          );

                        })
              ),

              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 12),
                child:  Row(

                  children: [

                    ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 40),
                    child :ElevatedButton(

                      onPressed: () {
                        addEinkaufItemDialog(context).then((value) => {
                          print(value.toString()),
                          einkaufeLists.add(value!),
                          setState(() {

                          })
                        });
                      },
                      style: ElevatedButton.styleFrom(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2), // <-- Radius
                        ),
                      ),
                      child: const Text('Abbreichen'),
                    )),

                    Spacer(),

                    ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(height: 40),
                        child :ElevatedButton(

                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2), // <-- Radius
                            ),
                          ),
                          child: const Text('Anderungen\nUbernehmen'),
                        )),




                  ],
                ),
              )

            ],
          ),


      )
    );
  }

}