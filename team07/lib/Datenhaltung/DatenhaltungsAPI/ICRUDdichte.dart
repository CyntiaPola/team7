

import 'dichte.dart';

abstract class ICRUDdichte {
  Future<Iterable> getDichten();
  Future<Dichte> getDichte(int zutatsname_id);
  Future<int> deleteDichte(int dichte_id);
  Future<int> setDichte(int zutatsname_id, double volumen_pro_100g);
}
