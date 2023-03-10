import 'package:flutter/material.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/KochenGUI/kochen_screen.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/RezepteGUI/RezepteSuchen/Rezeptbuch_home.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/VorratskammerGUI/VorratScreen.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Rezeptbuch_Controller.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/SettingsController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';
import '../EinkaufeGUI/EinkaufeHome.dart';
import '../PlaeneGUI/PlaeneHome.dart';

class HomeScreen extends StatefulWidget {
  SettingsController stateManager = getIt<SettingsController>();

  HomeScreen({Key? key}) : super(key: key);
  

  @override
  State<StatefulWidget> createState() => _HomeScreen();

  final Rezeptbuch_Controller rezeptbuch_controller = getIt<Rezeptbuch_Controller>();
}

class _HomeScreen extends State<HomeScreen> {



  @override
  void initState() {
    super.initState();
    widget.rezeptbuch_controller.gibAlleRezepte();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> _pages = <Widget>[
    VorratScreen(),
    EinkaufeHome(),
    Rezeptbuch_home(),
    KochenScreen(),
    PlaeneHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ValueListenableBuilder<int>(
                valueListenable: widget.stateManager.pageNotifier,
                builder: (context, page, _) {
                  return _pages.elementAt(page);
                })),
        bottomNavigationBar: ValueListenableBuilder<int>(
            valueListenable: widget.stateManager.pageNotifier,
            builder: (context, page, _) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.green,
                selectedFontSize: 10,
                selectedIconTheme: IconThemeData(color: Colors.white, size: 20),
                selectedItemColor: Colors.white,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Vorr??te',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag_outlined),
                    label: 'Eink??ufe',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.food_bank),
                    label: 'Rezepte',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bakery_dining_sharp),
                    label: 'Kochen',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: 'Pl??ne',
                  ),
                ],
                currentIndex: widget.stateManager.pageNotifier.value,
                onTap: widget.stateManager.onItemTapped,
              );
            }));
  }
}
