
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';



class TimerSchrittListenElement extends StatefulWidget {

  final int index;
  final stateManager = getIt<RezeptAnlegenController>();

  TimerSchrittListenElement(this.index);

  @override
  State<StatefulWidget> createState() => TimerSchrittListenState();

}

class TimerSchrittListenState extends State<TimerSchrittListenElement> {


  late TextEditingController _schrittController;
  late TextEditingController _timerController;

  @override
  void initState() {
    super.initState();
    _schrittController = TextEditingController();
    _timerController = TextEditingController();

  }

  @override
  void dispose() {
    _schrittController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _schrittController.text =  widget.stateManager.schrittNotifier.value[widget.index].schritt;
      _timerController.text =  widget.stateManager.schrittNotifier.value[widget.index].zeit

          ?? '';
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _schrittController,
          // speichert bei Änderung Schritt in Index i der Liste
          onChanged: (v) =>  widget.stateManager.schrittNotifier.value[widget.index].schritt = v,
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

           Row(children: <Widget>[
           Expanded(child:TextFormField(
              controller: _timerController,
              // speichert bei Änderung Zutat in Index i der Liste
              onChanged: (v) =>  widget.stateManager.schrittNotifier.value[widget.index].zeit = v,
              decoration: InputDecoration(
                  hintText: 'Zeit in Minuten'
              ),
             validator: (v) {
               if (v == null || v.trim().isEmpty) {
                 return ('Timer leer');
               }
               else if (v.contains(RegExp("[^0123456789]"))){
                 return 'Nur Zahlen erlaubt';
               }
               return null;
             },
            )),
    Expanded(child:Text("min")),])





      ],);
  }
}