import 'package:hive/hive.dart';

part 'zutats_Menge.g.dart';

@HiveType(typeId: 12)
class Zutats_Menge {
  @HiveField(0)
  int zutats_Menge_id;

  @HiveField(1)
  int rezept_id;

  @HiveField(2)
  int schritt_id;

  @HiveField(3)
  int zutaten_id;

  @HiveField(4)
  int teilmenge;

  @HiveField(5)
  String einheit;

  Zutats_Menge(
      {required this.zutats_Menge_id,
      required this.rezept_id,
      required this.schritt_id,
      required this.zutaten_id,
      required this.teilmenge,
      required this.einheit});
}
