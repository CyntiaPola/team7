import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';


class PortionsEingabe extends StatefulWidget {


  final stateManager = getIt<RezeptAnlegenController>();



  @override
  PortionsEingabeState createState() => PortionsEingabeState();
}

class PortionsEingabeState extends State<PortionsEingabe> {

  TextEditingController portionController=TextEditingController();

  @override
  void initState() {
    portionController.text=widget.stateManager.portionGeben();

    super.initState();

  }

  @override
  void dispose() {
    portionController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ Text(
          'Portionen:',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: TextFormField(
              onChanged: (v){
                widget.stateManager.portionSetzen(portionController.text);
              },
              controller: portionController,
              decoration: InputDecoration(hintText: 'Portion'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return ('Portion ist leer');
                }
                else if (v.contains(RegExp("[^0123456789]"))){
                  return 'Nur Zahlen erlaubt';
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
