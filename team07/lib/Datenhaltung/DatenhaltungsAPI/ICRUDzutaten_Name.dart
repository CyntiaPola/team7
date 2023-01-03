
import 'package:smart_waage/Datenhaltung/DatenhaltungsAPI/zutaten_Name.dart';

abstract class ICRUDzutaten_Name {

  ///Liefert alle ZuatenNamen aus der Datenbank
  Future<Iterable> getZutatenNamen();

  ///Liefert den Zutatennamen mit der id [zutaten_Name_id]
  Future<Zutaten_Name> getZutatenName(int zutaten_Name_id);


  ///Legt einen neuen Zutatennamen mit den Attributen [deutsch] und [english] an
  ///und gibt dessen id zurück
  ///
  /// Falls es schon einen Zutatennamen mit [deutsch] als Attribut deutsch,
  /// so wird kein neuer Name angelegt, sondern die ID des alten zurückggeben
  Future<int> setZutatenName(String deutsch, String english);

  /// Liefert die id des Zutatenname mit Name [name]
  /// wenn der Name nicht in der Datenbank existiert
  /// wird -1 zurückgegeben
  Future<int> getZutatenNameId(String name);
}
