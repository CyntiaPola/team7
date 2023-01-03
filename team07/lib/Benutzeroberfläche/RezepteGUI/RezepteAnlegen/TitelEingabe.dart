import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';



class TitelEingabe extends StatefulWidget {

  final stateManager = getIt<RezeptAnlegenController>();





  @override
  TitelEingabeState createState() => TitelEingabeState();
}

class TitelEingabeState extends State<TitelEingabe> {

  TextEditingController titelController=TextEditingController();

  @override
  void initState() {

    titelController.text=widget.stateManager.titelGeben();
    super.initState();

  }





  @override
  void dispose() {


   titelController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
      'Titel:',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 26,
      ),
    ),

    SizedBox(width: 10),
    Expanded(child:TextFormField(
      onChanged:(v){
        widget.stateManager.titelSetzen(titelController.text);},
    controller: titelController,
    decoration: InputDecoration(hintText: 'Titel eingeben'),
    validator: (v) {
    if (v == null || v.trim().isEmpty) {
    return 'Titel ist leer';
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
