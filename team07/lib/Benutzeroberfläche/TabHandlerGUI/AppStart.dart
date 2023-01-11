import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/KochenGUI/NormalSchritt.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/TabHandlerGUI/StartScreen.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';

import '../../Fachlogik/service_locator.dart';

class AppStart extends StatelessWidget {
   AppStart({super.key});

 
  @override
  void dispose() {
    sharedPrefsLoeschen();
    getIt<Kochen_Controller>(). timer!.cancel();

    //Hive.close();
  }

  Future<void> sharedPrefsLoeschen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    AlanVoice.addButton("19bcd6058927fc587458335c9e6b18f32e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //home:ReceipeListScreen(),
      home: StartScreen(),
    );
  }
}