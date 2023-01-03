import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

import '../../../Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';



class ZutatenListenElement extends StatefulWidget {
  final int index;
  final stateManager = getIt<RezeptAnzeigenController>();
  ZutatenListenElement(this.index);

  @override
  _ZutatenListenElementState createState() => _ZutatenListenElementState();
}
class _ZutatenListenElementState extends State<ZutatenListenElement> {
  late TextEditingController _zutatenController;
  late TextEditingController _mengenController;
  late TextEditingController _einheitsController;
  @override
  void initState() {
    super.initState();
    _zutatenController = TextEditingController();
    _mengenController = TextEditingController();
    _einheitsController = TextEditingController();
  }
  @override
  void dispose() {
    _zutatenController.dispose();
    _mengenController.dispose();
    _einheitsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _zutatenController.text = widget.stateManager.einkaufslisteNotifier.value[widget.index].name;
      _mengenController.text = widget.stateManager.einkaufslisteNotifier.value[widget.index].menge;
      _einheitsController.text = widget.stateManager.einkaufslisteNotifier.value[widget.index].einheit
          ?? '';
    });
    return Row(

       children:
       <Widget>
       [
        Expanded(child: TextFormField(
      controller: _zutatenController,
      // speichert bei Änderung Zutat in Index i der Liste
      onChanged: (v) => widget.stateManager.einkaufslisteNotifier.value[widget.index].name = v,
      decoration: InputDecoration(
          hintText: 'Zutat'
      ),
      validator: (v){
        if(v==null||v.trim().isEmpty) return 'Zutat leer';
        return null;
      },
    )),
       Expanded(child:  TextFormField(
           controller: _mengenController,
           // speichert bei Änderung menge in Index i der Liste
           onChanged: (v) => widget.stateManager.einkaufslisteNotifier.value[widget.index].menge = v,
           decoration: InputDecoration(
               hintText: 'Menge'
           ),
           validator: (v){
             if(v==null||v.trim().isEmpty) {return 'Menge leer';}
             else if (v.contains(RegExp("[^0123456789.]"))){
               return 'Nur Zahlen erlaubt';
             }
             return null;
           },
         )),

         Expanded(child:TextFormField(
           controller: _einheitsController,
           // speichert bei Änderung einheit in Index i der Liste
           onChanged: (v) => widget.stateManager.einkaufslisteNotifier.value[widget.index].einheit = v,
           decoration: InputDecoration(
               hintText: 'Einheit'
           ),
           validator: (v){
             if(v==null||v.trim().isEmpty) return 'Einheit leer';
             return null;
           },
         )),

         widget.index==widget.stateManager.einkaufslisteNotifier.value.length-1 && widget.index>0?
           _addRemoveButtonZutaten(false, widget.index) : Container(),


         _addRemoveButtonZutaten(widget.index== widget.stateManager.einkaufslisteNotifier.value.length - 1, widget.index),
       ],
    );


  }

  Widget _addRemoveButtonZutaten(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          widget.stateManager.einkaufszutatHinzufuegen("", "", "");
        } else



          widget.stateManager.einkaufszutatLoeschen(index);

      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }




}