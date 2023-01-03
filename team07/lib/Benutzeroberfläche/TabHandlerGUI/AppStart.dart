import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Kochen_Controller.dart';

import '../../Fachlogik/service_locator.dart';
import 'home_screen.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

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
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //home:ReceipeListScreen(),
      home: HomeScreen(),
    );
  }
}