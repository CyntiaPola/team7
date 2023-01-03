

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';



class SplitButton extends StatelessWidget{
  final String text;
  int index;

  final stateManager = getIt<RezeptAnlegenController>();

  SplitButton({ required this.text, required this.index}) ;



  @override
  Widget build(BuildContext context) {
    return

        SizedBox(
      width: text.length*11+20,


          child: Container(
          alignment: Alignment.center,

              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child:

          Row(
              children:
              <Widget>[

    Expanded(
    child: InkWell(
    onTap: () {},
    child: Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
    color: Colors.lightGreen,
    borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(6),
    topLeft: Radius.circular(6))),
    child: Text(text,
    style: TextStyle(
    fontSize: 17,
    )),
    ))),

    InkWell(
    onTap: () {stateManager.kategorieLoeschen(index);},
    child: Container(
    alignment: Alignment.center,
    child: Text("X ",
    style: TextStyle(
    color: Colors.white, fontSize: 17)),
    ))





    ]
      )

      ));
  }

}