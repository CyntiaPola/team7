
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

class MengenSchrittListenElement extends StatefulWidget {

  final int index;
  final stateManager = getIt<RezeptAnlegenController>();

  MengenSchrittListenElement(this.index);

  @override
  State<StatefulWidget> createState() => MengenSchrittListenState();

}

class MengenSchrittListenState extends State<MengenSchrittListenElement> {


  late TextEditingController _schrittController;
  late TextEditingController _zutatenController;
  late TextEditingController _mengenController;
  late TextEditingController _einheitsController;

  @override
  void initState() {
    super.initState();
    _schrittController = TextEditingController();
    _zutatenController = TextEditingController();
    _mengenController = TextEditingController();
    _einheitsController = TextEditingController();

  }

  @override
  void dispose() {
    _schrittController.dispose();
    _zutatenController.dispose();
    _mengenController.dispose();
    _einheitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _schrittController.text = widget.stateManager.schrittNotifier.value[widget.index].schritt;
      _zutatenController.text = widget.stateManager.schrittNotifier.value[widget.index].zutat;
      _mengenController.text = widget.stateManager.schrittNotifier.value[widget.index].menge;
      _einheitsController.text = widget.stateManager.schrittNotifier.value[widget.index].einheit
          ?? '';
    });
    return Column(

      children:
      <Widget>
      [
         TextFormField(
          controller: _schrittController,
          // speichert bei Änderung Schritt in Index i der Liste
          onChanged: (v) => widget.stateManager.schrittNotifier.value[widget.index].schritt = v,
          decoration: InputDecoration(
            hintText: 'Schritt ' + (widget.index + 1).toString(),
          ),
          validator: (v) {
            if (v == null || v
                .trim()
                .isEmpty)
              return 'Schritt ' + (widget.index + 1).toString() + ' leer';
            return null;
          },
        ),
        Row(

          children:
          <Widget>
          [
            Expanded(child: TextFormField(
              controller: _zutatenController,
              // speichert bei Änderung Zutat in Index i der Liste
              onChanged: (v) => widget.stateManager.schrittNotifier.value[widget.index].zutat = v,
              decoration: InputDecoration(
                  hintText: 'Zutat'
              ),
              validator: (v){
                if(v==null||v.trim().isEmpty) return 'Zutat leer';
                return null;
              },
            )),
            Expanded(child: TextFormField(
              controller: _mengenController,
              // speichert bei Änderung menge in Index i der Liste
              onChanged: (v) => widget.stateManager.schrittNotifier.value[widget.index].menge = v,
              decoration: InputDecoration(
                  hintText: 'Menge'
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return ('Menge leer');
                }
                else if (v.contains(RegExp("[^0123456789]"))){
                  return 'Nur Zahlen erlaubt';
                }
                return null;
              },
            )),


            SizedBox (width: 70,
                height:60,
                child: DropdownButtonFormField<String>(

                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 0),
                    ),
                    filled:false,
                  ),
                  dropdownColor: Colors.greenAccent,
                  onChanged: (String? newValue) {
                    setState(() {
                      _einheitsController.text = newValue!;
                      widget.stateManager.schrittNotifier.value[widget.index].einheit = newValue;
                    });
                  },
                  items: <String>['g', 'ml'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                )),
          ],)

      ],);
  }




}