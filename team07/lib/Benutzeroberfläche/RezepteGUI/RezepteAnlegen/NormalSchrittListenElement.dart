

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
import 'package:smart_waage/Fachlogik/service_locator.dart';

class NormalSchrittListenElement extends StatefulWidget  {

  final int index;
  final stateManager = getIt<RezeptAnlegenController>();
 NormalSchrittListenElement(this.index);
  @override
  State<StatefulWidget> createState() => NormalSchrittListenState();

}

class NormalSchrittListenState extends State<NormalSchrittListenElement> {



  late TextEditingController _schrittController;
  @override
  void initState() {
    super.initState();
    _schrittController = TextEditingController();
  }
  @override
  void dispose() {
    _schrittController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _schrittController.text =  widget.stateManager.schrittNotifier.value[widget.index].schritt ?? '';

    });
    return Row(

      children:
      <Widget>
      [
        Expanded(child: TextFormField(
          controller: _schrittController,
          // speichert bei Änderung Schritt in Index i der Liste
          onChanged: (v) => { widget.stateManager.schrittNotifier.value[widget.index].schritt = v},
          decoration: InputDecoration(
              hintText: 'Schritt '+ (widget.index+1).toString(),
          ),
          validator: (v){
            if(v==null||v.trim().isEmpty) return 'Schritt '+  (widget.index+1).toString()+ ' leer';
            return null;
          },
        )),

      ],);
  }
}