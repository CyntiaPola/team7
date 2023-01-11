

import 'package:smart_waage/Benutzeroberfl%C3%A4che/EinkaufeGUI/EinkaufeHome.dart';

class Einheit{
  String value;
  String description;

  Einheit(this.value,this.description);

  static Einheit fromString(String value){
    return EinheitArrays.firstWhere((element) => element.value==value,  orElse: () => EinheitArrays[0]);
  }

  static Einheit fromEinkaufeModel(EinkaufeModel einkaufeModel){
    return EinheitArrays.firstWhere((element) => element.value==einkaufeModel.unit ,  orElse: () => EinheitArrays[0]) ;
  }
}

 final List<Einheit> EinheitArrays = [
   Einheit("g","gramm"),
   Einheit("ml","milli liter"),
   Einheit("Stück","Stück"),
   Einheit("Prise","Prise"),
];