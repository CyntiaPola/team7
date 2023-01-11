import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/TabHandlerGUI/LetztesRezeptLaden.dart';

import '../../Fachlogik/SteuerungsAPI/Kochen_Controller.dart';
import '../../Fachlogik/service_locator.dart';
import 'home_screen.dart';

class StartScreen extends StatefulWidget{



  @override
  State<StatefulWidget> createState() => _StartScreen();

}

class _StartScreen extends State<StartScreen>{

  AudioCache player = AudioCache();



  @override
  void initState(){
    super.initState();
    player.play("sounds/braten.mp3");



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
            Column(children:[

              SizedBox(height: 100),
              Text("Viel Spaß beim Kochen und Genießen mit SmartWaage! "
                  ,
                style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,),

              SizedBox(height: 50),
              Image.asset(
                "assets/images/fried-egg-1329_512.gif",
                height: 200.0,
                width: 250.0,
              ),

              SizedBox(width: 300, child: Text(
                  "Bitte denk daran, dass du zum Einspeichern "
                  "eines Rezepts eine Verbindung zum "
                  "Internet benötigst, damit wir die "
                  "entsprechenden Zusatzdaten zu deinen "
                  "Angaben laden können.",
                style: TextStyle(fontSize: 10, color: Colors.red),
                textAlign: TextAlign.center,)),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () async {

              bool unabgeschlossenesRezeptVorhanden= await getIt<Kochen_Controller>().unabgeschlossenesRezeptVorhanden();
              Navigator.pop(context);
              if(unabgeschlossenesRezeptVorhanden){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LetztesRezeptLaden(
                        )));
              }
              else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                      )));}
            }, child: Text("Loslegen"), )]))


    );
  }


}
