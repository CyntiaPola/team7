import 'package:hive/hive.dart';

part 'gekochtesRezept.g.dart';

@HiveType(typeId: 2)
class GekochtesRezept {
  @HiveField(0)
  int gekochtesRezept_ID;

  @HiveField(1)
  int rezept_id;

  @HiveField(2)
  var datum;

  @HiveField(3)
  bool abgeschlossen;

  @HiveField(4)
  int naehrwert_id;

  @HiveField(5)
  int status;

  @HiveField(6)
  double portion;

  GekochtesRezept(
      {required this.gekochtesRezept_ID,
      required this.rezept_id,
      required this.datum,
      required this.abgeschlossen,
      required this.naehrwert_id,
      required this.status,
      required this.portion});
}
