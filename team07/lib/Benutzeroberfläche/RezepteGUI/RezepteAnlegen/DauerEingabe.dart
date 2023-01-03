

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

class DauerEingabe extends StatefulWidget {


  final stateManager = getIt<RezeptAnlegenController>();




  @override
  DauerEingabeState createState() => DauerEingabeState();
}

class DauerEingabeState extends State<DauerEingabe> {


  TextEditingController dauerController=TextEditingController();

  @override
  void initState() {

    dauerController.text=widget.stateManager.dauerGeben();

    super.initState();

  }

  @override
  void dispose() {
    dauerController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dauer:',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: TextFormField(
              onChanged: (v){
                widget.stateManager.dauerSetzen(dauerController.text);
              },
              controller: dauerController,
              decoration: InputDecoration(hintText: 'in Min'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return ('Dauer ist leer');
                }
                else if (v.contains(RegExp("[^0123456789]"))){
                  return 'Nur Zahlen erlaubt';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ]
    );
  }

}
