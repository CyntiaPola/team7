import 'package:hive/hive.dart';

part 'naehrwerte_pro_100g.g.dart';

@HiveType(typeId: 5)
class Naehrwerte_pro_100g {
  @HiveField(0)
  int naehrwert_id;

  @HiveField(1)
  int zutatsname_id;

  @HiveField(2)
  double kcal;

  @HiveField(3)
  double fett;

  @HiveField(4)
  double gesaettigteFettsaeuren; //Name geändert

  @HiveField(5)
  double zucker;

  @HiveField(6)
  double eiweiss; //Name geändert

  @HiveField(7)
  double salz;

  Naehrwerte_pro_100g(
      {required this.naehrwert_id,
      required this.zutatsname_id,
      required this.kcal,
      required this.fett,
      required this.gesaettigteFettsaeuren,
      required this.zucker,
      required this.eiweiss,
      required this.salz});
}
