
import 'naehrwerte_pro_100g.dart';

abstract class ICRUDnaehrwerte_pro_100g {

  Future<int> setNaehrwerte_pro_100g(int zutatsname_id, double kcal, double fett, double gesaettigteFettsaeuren,
      double zucker, double eiweiss, double salz);

  Future<Naehrwerte_pro_100g>? getNaehrwerte_pro_100g(int naehrwerte_pro_100g_id);

  Future<int> getNaehrwertIdByNameId(int zutatsname_id);
  Future<Naehrwerte_pro_100g>? getNaehrwertByNameId(zutatennameid);
}
