import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/EinkaufeGUI/EinkaufeHome.dart';
import 'package:smart_waage/Benutzeroberfl%C3%A4che/EinkaufeGUI/util.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Einkaufsliste_Controller.dart';

import '../../../Fachlogik/service_locator.dart';



Future<EinkaufeModel?> addEinkaufItemDialog(BuildContext context,EinkaufeModel   einkaufeModel) async {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 6,
          backgroundColor: Colors.transparent,
          child: _DialogWithTextField(context,einkaufeModel),
        );
      });
}

Widget _DialogWithTextField(BuildContext context,EinkaufeModel einkaufeModel) {


  final mengeController = TextEditingController(text: '${einkaufeModel.weight}');

  final statemanager = getIt<Einkaufsliste_Controller>();

  Einheit? dropdownValue = Einheit.fromEinkaufeModel(einkaufeModel);

  String zutatName = einkaufeModel.name;
  return Container(


    constraints: const BoxConstraints(minWidth: 100, maxWidth: 500,maxHeight: 500),
    decoration: const BoxDecoration(
      color:  Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),

  child: Column(
    children: <Widget>[

      Expanded(
          child:
          Column(

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
                    child: RawAutocomplete<String>(
                      fieldViewBuilder:
                      ((context, textEditingController, focusNode, onFieldSubmitted) =>
                          TextFormField( // exposed text field
                            controller: textEditingController,
                            maxLines: 1,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            focusNode: focusNode,
                            onFieldSubmitted: (String value) {
                              onFieldSubmitted();
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          )),

                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: Container(
                              height: 200.0,
                              constraints: const BoxConstraints(minWidth: 100, maxWidth: 400),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option = options.elementAt(index);
                                  return GestureDetector(
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: ListTile(
                                      title: Text(option),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },

                      optionsBuilder: (textEditingValue) {
                        return statemanager.getList().where((String option) {
                          return option.contains(textEditingValue.text);
                        });
                      },

                      onSelected: (value){
                        zutatName = value;
                      },
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                ),

                const SizedBox(height: 5),

                Padding(
                    padding: const EdgeInsets.only(top: 10, right: 15, left: 15),


                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        const Text(
                          'Einheit',
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                     DropdownButtonFormField<Einheit>(

                         value: dropdownValue,
                         onChanged: (Einheit? newValue) {
                           dropdownValue = newValue;
                         },
                         items: EinheitArrays
                             .map<DropdownMenuItem<Einheit>>((Einheit einheit) {
                           return DropdownMenuItem<Einheit>(
                             value: einheit,
                             child: Text(einheit.value),
                           );
                         }).toList(),
                         validator: (Einheit? value) {
                           if (value == null) {
                             return 'Must make a selection.';
                           }
                           return null;
                         },
                       )],
                    )


                ),
                const SizedBox(height: 10)
              ]
          ),

      ),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 40),
              child :ElevatedButton(

                onPressed: () {

                  Navigator.of(context).pop(EinkaufeModel(einkaufeModel.id,zutatName, int.parse(mengeController.text), dropdownValue?.value??''));
                },
                style: ElevatedButton.styleFrom(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // <-- Radius
                  ),
                ),
                child: Text("Save".toUpperCase()),
              )),

          const SizedBox(width: 20),
          ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 40),
              child :ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2), // <-- Radius
                  ),
                ),
                child: const Text('Cancel'),
              )),




        ],
      ),
      const SizedBox(height: 10),
    ],
  ),

);
}


Future<bool?> deleteItem(BuildContext context) async {
  return showDialog(
      barrierDismissible: false,
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