


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../EinkaufeHome.dart';

class EinkaufeHeader  extends StatefulWidget {


  @override
  EinkaufeHeaderState createState() {
     return EinkaufeHeaderState();
  }

}

class EinkaufeHeaderState extends State<EinkaufeHeader> {


  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(4),
      height: 40,
      child: Row(

        children: [
        Expanded(
          flex: 1, // 20%
          child:Container(
              height:MediaQuery.of(context).size.height,
              // color: Colors.blue,
              alignment: Alignment.centerLeft,
              // child: const Text("Gekauft")
              child: const Text("")
          )
        ),
          Expanded(
            flex: 5, // 60%
            child: Container( alignment: Alignment.centerLeft,
                height:MediaQuery.of(context).size.height ,
                // color: Colors.red,
                child: RichText(text: const TextSpan(
                  // Here is the explicit parent TextStyle
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Name', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ))
            ),
          ),

          Expanded(
            flex: 2, // 20%
            child: Container(
                height:MediaQuery.of(context).size.height,
                // color: Colors.green,
                alignment: Alignment.centerLeft,
                child: RichText(text: const TextSpan(
                  // Here is the explicit parent TextStyle
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Menge', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ))
            ),
          ),
          Expanded(
            flex: 3, // 20%
            child: Container(
                height:MediaQuery.of(context).size.height,
                // color: Colors.blue,
                alignment: Alignment.centerLeft,
                child: RichText(text: const TextSpan(
                  // Here is the explicit parent TextStyle
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Einheit', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ))
            ),
          ),


        ],
      ),
    );
  }

}