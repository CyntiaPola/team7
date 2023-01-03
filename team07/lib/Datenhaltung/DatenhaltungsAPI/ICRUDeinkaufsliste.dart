

import 'einkaufsliste.dart';

abstract class ICRUDeinkaufsliste {
  Future<Iterable> getEinkaufslisten();
  Future<Einkaufsliste> getEinkaufsliste(int einkaufsliste_id);
  Future<int> deleteEinkaufsliste(int einkaufsliste_id);
  Future<int> setEinkaufsliste(
      int zutatsname_id, int rezept_id, int menge, String einheit);
}
