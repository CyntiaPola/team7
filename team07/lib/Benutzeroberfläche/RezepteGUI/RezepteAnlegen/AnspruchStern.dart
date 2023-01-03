

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';


class AnspruchStern extends StatefulWidget {

  final stateManager = getIt<RezeptAnlegenController>();


  @override
  AnspruchSternState createState() => AnspruchSternState();
}

class AnspruchSternState extends State<AnspruchStern> {

  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    return Column(

        children: <Widget>[
          Text(
            'Anspruch:',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          ValueListenableBuilder<List<Color>>(
              valueListenable: widget.stateManager.anspruchNotifier,
              builder: (context, farbe, _) {
                return

          Row(
            children: [
             SizedBox(width: 20,child:IconButton(onPressed: () {  widget.stateManager.anspruchFestlegen(0);}, icon: Icon(Icons.star, color: farbe[0],))),
              SizedBox(width: 20,child:IconButton(onPressed: () {  widget.stateManager.anspruchFestlegen(1); }, icon: Icon(Icons.star, color: farbe[1]))),
              SizedBox(width: 20,child:IconButton(onPressed: () {  widget.stateManager.anspruchFestlegen(2); }, icon: Icon(Icons.star, color: farbe[2]))),
              SizedBox(width: 20,child:IconButton(onPressed: () {  widget.stateManager.anspruchFestlegen(3); }, icon: Icon(Icons.star, color: farbe[3]))),
              SizedBox(width: 20,child:IconButton(onPressed: () {  widget.stateManager.anspruchFestlegen(4); }, icon: Icon(Icons.star, color: farbe[4]))),



            ]
          );
              }),
          SizedBox(
            height: 20,
          ),]);
  }

}


