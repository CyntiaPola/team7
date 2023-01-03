import 'package:hive/hive.dart';

part 'schritt.g.dart';

@HiveType(typeId: 7)
class Schritt {
  @HiveField(0)
  int schritt_id;

  @HiveField(1)
  int schrittnummer;

  @HiveField(2)
  int rezept_id;

  @HiveField(3)
  int timer;

  @HiveField(4)
  bool waage;

  @HiveField(5)
  String beschreibung;

  Schritt(
      {required this.schritt_id,
      required this.schrittnummer,
      required this.rezept_id,
      required this.timer,
      required this.waage,
      required this.beschreibung});
}
