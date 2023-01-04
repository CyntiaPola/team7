import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/EinkaufeGUI/EinkaufeHome.dart';



Future<EinkaufeModel?> addEinkaufItemDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 6,
          backgroundColor: Colors.transparent,
          child: _DialogWithTextField(context),
        );
      });
}

Widget _DialogWithTextField(BuildContext context) {
  final nameController = TextEditingController();
  final mengeController = TextEditingController();
  final einheitController = TextEditingController();
  return Container(

  height: 280,
  decoration: const BoxDecoration(
    color:  Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  child: Column(
    children: <Widget>[
      const SizedBox(height: 5),
      Text(
        "ADD Item".toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      const SizedBox(height: 5),
      Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
          child: TextFormField(
            controller: nameController,
            maxLines: 1,
            autofocus: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )
      ),

      Padding(
          padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
          child: TextFormField(
            controller: mengeController,
            maxLines: 1,
            autofocus: false,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              labelText: 'Menge',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )
      ),
      const SizedBox(height: 5),

      Padding(
          padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
          child: TextFormField(
            controller: einheitController,
            maxLines: 1,
            autofocus: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Einheit',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )
      ),
      const SizedBox(height: 10),


      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 40),
              child :ElevatedButton(

                onPressed: () {
                  Navigator.of(context).pop(EinkaufeModel(AUTO_ID++,nameController.text, int.parse(mengeController.text), einheitController.text));
                },
                style: ElevatedButton.styleFrom(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // <-- Radius
                  ),
                ),
                child: Text("Save".toUpperCase()),
              )),

          const SizedBox(width: 8),
          ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 40),
              child :ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // <-- Radius
                  ),
                ),
              )),




        ],
      ),
    ],
  ),
);
}


Future<bool?> deleteItem(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(

          content: const Text('Wollen Sie Ihre Anderungen an der Einkaufsliste wirklich ubernehmen'),
          actions: [
            // The "Yes" button
            TextButton(
                onPressed: () {

                  Navigator.of(context).pop(true);
                },
                child: const Text('Abbreichen')),
            TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop(false);
                },
                child: const Text('Anderungen\nUbernehmen'))
          ],
        );
      });
}