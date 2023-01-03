 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


 import 'package:smart_waage/Fachlogik/SteuerungsAPI/RezeptAnlegenController.dart';
 import 'package:smart_waage/Fachlogik/service_locator.dart';


class KategorieLeiste extends StatefulWidget{


 final stateManager = getIt<RezeptAnlegenController>();
 @override
 KategorieLeisteState createState() => KategorieLeisteState();
}
 class KategorieLeisteState extends State<KategorieLeiste> {

final TextEditingController _kategorieZutatController= TextEditingController();
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

     return Row(

       children:
       <Widget>
       [
       Expanded(child:TypeAheadField(
       animationStart: 0,
       animationDuration: Duration.zero,
       textFieldConfiguration:  TextFieldConfiguration(
         autofocus: false,
         style: TextStyle(fontSize: 15),
         controller: _kategorieZutatController,
         decoration:InputDecoration(hintText: 'Kategorie'),
       ),
       suggestionsBoxDecoration: SuggestionsBoxDecoration(
           color: Colors.lightBlue[50]
       ),
       suggestionsCallback: (pattern) async {
         List<String> matches = await widget.stateManager.gibAlleKategorien();

         matches.retainWhere((s){
           return s.toLowerCase().contains(pattern.toLowerCase());
         });
         return matches;
       },
       itemBuilder: (context, sone) {
         return Card(
             child: Container(
               padding: EdgeInsets.all(10),
               child:Text(sone.toString()),
             )
         );
       },
       onSuggestionSelected: (suggestion) {
         _kategorieZutatController.text=suggestion;
       },
     )),
         _addRemoveButtonKategorien(),


       ],);
   }

   Widget _addRemoveButtonKategorien( ) {
     return InkWell(
       onTap: () {

           widget.stateManager.kategorieHinzufuegen(_kategorieZutatController.text);
           _kategorieZutatController.text="";

       },
       child: Container(
         width: 30,
         height: 30,
         decoration: BoxDecoration(
           color: Colors.green,
           borderRadius: BorderRadius.circular(20),
         ),
         child: Icon(
            Icons.add ,
           color: Colors.white,
         ),
       ),
     );
   }

}