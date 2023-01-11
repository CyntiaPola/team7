import 'package:hive/hive.dart';

part 'vorratskammerinhalt.g.dart';

@HiveType(typeId: 9)
class Vorratskammerinhalt {
  @HiveField(0)
  int vorratskammerinhalt_id;

  @HiveField(1)
  int zutatsname_id;

  @HiveField(2)
  int menge;

  @HiveField(3)
  String einheit;

  Vorratskammerinhalt(
      {required this.vorratskammerinhalt_id,
      required this.zutatsname_id,
      required this.menge,
      required this.einheit});
}
