import 'package:hive/hive.dart';

part 'zutaten.g.dart';

@HiveType(typeId: 10)
class Zutaten {
  @HiveField(0)
  int zutaten_id;

  @HiveField(1)
  int name_id;

  @HiveField(2)
  int rezept_id;

  @HiveField(3)
  int naehrwert_id;

  @HiveField(4)
  int menge_pp;

  @HiveField(5)
  String einheit;

  @HiveField(6)
  int volumen_id; //?

  @HiveField(7)
  int masse_id;

  @HiveField(8)
  int dichte_id;

  @HiveField(9)
  bool skalierbar;

  Zutaten(
      {required this.zutaten_id,
      required this.name_id,
      required this.rezept_id,
      required this.naehrwert_id,
      required this.menge_pp,
      required this.einheit,
      required this.volumen_id,
      required this.masse_id,
      required this.dichte_id,
      required this.skalierbar});
}
