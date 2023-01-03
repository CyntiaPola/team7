import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Fachlogik/SteuerungsAPI/RezeptAnzeigenController.dart';
import '../../../Fachlogik/SteuerungsAPI/Zutat_Rezeptanzeige.dart';
import '../../../Fachlogik/service_locator.dart';
import 'ZutatenListeElement.dart';

class RezeptEinplanen extends StatefulWidget {


  final stateManager = getIt<RezeptAnzeigenController>();


  @override
  RezeptEinplanenState createState() => RezeptEinplanenState();
}

class RezeptEinplanenState extends State<RezeptEinplanen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Form(
        key: _formKey,
        child: Scaffold(
        backgroundColor: Colors.green[200],
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                widget.stateManager.resetZutatenliste();
              },
            ),
            title: Text(widget.stateManager.titelGeben() + " planen"),
            actions: []),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 20),
          Text("Zutaten",
          style: TextStyle(fontSize: 30),),
              ValueListenableBuilder<List<Zutat_Rezeptanzeige>>(
                  valueListenable: widget.stateManager.einkaufslisteNotifier,
                  builder: (context, eingabeliste, _) {
                    return Column(children: [..._getZutaten()]);
                  }),
          Row(children: <Widget>[
            SizedBox(width: 20),
            ElevatedButton(
                onPressed: () async => {
                  widget.stateManager.resetZutatenliste(),

                  widget.stateManager.SetzeDatumZurAusfuehrung(
                    await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate:DateTime(2000),
                lastDate: DateTime(2101),
                      helpText: widget.stateManager.titelGeben() + " kochen am"
                )),
                  if(widget.stateManager.GibDatumZurAusfuehrung()!= null ){
                    Navigator.of(context).pop(),
                    widget.stateManager.gekochtesRezeptSpeichern(),
                  }


                },
                child: Text("nichts hinzufügen")),
            SizedBox(width: 40),
            ElevatedButton(
                onPressed: () async => {

                if (_formKey.currentState!.validate()) {
                widget.stateManager.resetZutatenliste(),

            widget.stateManager.SetzeDatumZurAusfuehrung(
                await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate:DateTime(2000),
                lastDate: DateTime(2101)
            )),
            if(widget.stateManager.GibDatumZurAusfuehrung()!= null ){
      Navigator.of(context).pop(),
    widget.stateManager.gekochtesRezeptSpeichern(),
              widget.stateManager.einkaufsListeUebernehmen(),
    }
                }

                },
                child: Text("zur Einkaufsliste \n hinzufügen")),
          ])
        ]))));
  }

  List<Widget> _getZutaten() {
    List<Widget> neuZutatenList = [];
    for (int i = 0; i < widget.stateManager.einkaufslisteNotifier.value.length; i++) {
      neuZutatenList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: ZutatenListenElement(i)),

            SizedBox(
              width: 16,
            ),
          ],
        ),
      ));
    }
    return neuZutatenList;
  }

}
