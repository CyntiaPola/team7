

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

class SplitButton extends StatelessWidget{
  final String text;

  final stateManager = getIt<Rezeptbuch_Controller>();

  var gewuenscht;

  SplitButton({ required this.text, required this.gewuenscht}) ;



  @override
  Widget build(BuildContext context) {
    return

        SizedBox(
      width: text.length*11+20,


          child: Container(
          alignment: Alignment.center,

              decoration: BoxDecoration(
                color: gewuenscht? Colors.lightGreen : Colors.redAccent,
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
        color: gewuenscht? Colors.lightGreen : Colors.redAccent,
    borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(6),
    topLeft: Radius.circular(6))),
    child: Text(text,
    style: TextStyle(
    fontSize: 17,
    )),
    ))),

    InkWell(
    onTap: () {stateManager.kategorieZutatLoeschen(text);},
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