import 'package:hive/hive.dart';

part 'einkaufsliste.g.dart';

@HiveType(typeId: 1)
class Einkaufsliste {
  @HiveField(0)
  int einkaufsliste_id;

  @HiveField(1)
  int zutatsname_id;

  @HiveField(2)
  int rezept_id;

  @HiveField(3)
  int menge;

  @HiveField(4)
  String einheit;

  Einkaufsliste(
      {required this.einkaufsliste_id,
      required this.zutatsname_id,
      required this.rezept_id,
      required this.menge,
      required this.einheit});
}
