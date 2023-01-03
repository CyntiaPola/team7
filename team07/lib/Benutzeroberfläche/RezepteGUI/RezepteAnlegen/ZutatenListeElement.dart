import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';



class ZutatenListenElement extends StatefulWidget {
  final int index;
  final stateManager = getIt<RezeptAnlegenController>();
  ZutatenListenElement(this.index);

  @override
  _ZutatenListenElementState createState() => _ZutatenListenElementState();
}
class _ZutatenListenElementState extends State<ZutatenListenElement> {
  late TextEditingController _zutatenController;
  late TextEditingController _mengenController;
  late String _einheitsController;
  @override
  void initState() {
    super.initState();
    _zutatenController = TextEditingController();
    _mengenController = TextEditingController();
    _einheitsController = "g";
    widget.stateManager.zutatenNotifier.value[widget.index].einheit='g';
  }
  @override
  void dispose() {
    _zutatenController.dispose();
    _mengenController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _zutatenController.text = widget.stateManager.zutatenNotifier.value[widget.index].name;
      _mengenController.text = widget.stateManager.zutatenNotifier.value[widget.index].menge;
      _einheitsController = widget.stateManager.zutatenNotifier.value[widget.index].einheit
          ?? '';
    });
    return Row(

       children:
       <Widget>
       [
        Expanded(child: TextFormField(
      controller: _zutatenController,
      // speichert bei Änderung Zutat in Index i der Liste
      onChanged: (v) => widget.stateManager.zutatenNotifier.value[widget.index].name = v,
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
           onChanged: (v) => widget.stateManager.zutatenNotifier.value[widget.index].menge = v,
           decoration: InputDecoration(
               hintText: 'Menge'
           ),
           validator: (v){
             if(v==null||v.trim().isEmpty) {return 'Menge leer';}
             else if (v.contains(RegExp("[^0123456789]"))){
               return 'Nur Zahlen erlaubt';
             }
             return null;
           },
         )),


    SizedBox(width:5),
    SizedBox (width: 70,
        height:60,
        child:DropdownButtonFormField(

    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0),
    ),
    filled:false,
    ),
    dropdownColor: Colors.greenAccent,
    value: _einheitsController,
    onChanged: (String? newValue) {
    setState(() {
      _einheitsController = newValue!;
      widget.stateManager.zutatenNotifier.value[widget.index].einheit = newValue;
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
         SizedBox(width:5),

         widget.index==widget.stateManager.zutatenNotifier.value.length-1 && widget.index>0?
         _addRemoveButtonZutaten(false, widget.index) : Container(),


         _addRemoveButtonZutaten(widget.index== widget.stateManager.zutatenNotifier.value.length - 1, widget.index),
       ],
    );


  }

  Widget _addRemoveButtonZutaten(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          widget.stateManager.zutatHinzufuegen("", "", "");
        } else
          widget.stateManager.zutatLoeschen(index);

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