import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import '../../Fachlogik/service_locator.dart';
import 'home_screen.dart';

class LetztesRezeptLaden extends StatefulWidget{



  @override
  State<StatefulWidget> createState() => _LetztesRezeptLaden();

}

class _LetztesRezeptLaden extends State<LetztesRezeptLaden>{




  @override
  void initState(){
    super.initState();



  }






  @override
  void dispose(){

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: Center(
            child:
            Column(
              children:
              [
                SizedBox(height:100),
                Text("Es liegt ein nicht abgeschlossenes  Rezept vom letzten Mal vor. "
                    "Willst du es weiterkochen?",
                style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,),

              SizedBox(height:100),

              ElevatedButton(onPressed: () async {
              await
              getIt<Kochen_Controller>().moeglichesLetztesRezeptLaden();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                      )));
            }, child: Text("Rezept laden"), ),
                SizedBox(height:20),
              ElevatedButton(onPressed: () async {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                        )));
              }, child: Text("Vielleicht beim nächsten Appstart"), ),

                SizedBox(height:20),
              ElevatedButton(onPressed: () async {
                getIt<Kochen_Controller>().letztesRezeptLoeschen();
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                        )));
              }, child: Text("Rezept verwerfen"), ),



            ]))


);
  }


}
