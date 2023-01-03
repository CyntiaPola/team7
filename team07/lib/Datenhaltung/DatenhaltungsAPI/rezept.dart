import 'package:hive/hive.dart';

part 'rezept.g.dart';

@HiveType(typeId: 6)
class Rezept {
  @HiveField(0)
  int rezept_id;

  @HiveField(1)
  String titel;

  @HiveField(2)
  int dauer;

  @HiveField(3)
  int anspruch;

  @HiveField(4)
  String bild;

  Rezept(
      {required this.rezept_id,
      required this.titel,
      required this.dauer,
      required this.anspruch,
      required this.bild});
}
