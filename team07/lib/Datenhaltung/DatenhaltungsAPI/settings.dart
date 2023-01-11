import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 8)
class Settings {
  @HiveField(0)
  int id;

  @HiveField(1)
  int toleranzbereich;

  @HiveField(2)
  bool vorratskammerNutzen;

  @HiveField(3)
  int letztesRezept_id;

  @HiveField(4)
  bool naehrwerteAnzeigen;

  Settings(
      {required this.id,
      required this.toleranzbereich,
      required this.vorratskammerNutzen,
      required this.letztesRezept_id,
      required this.naehrwerteAnzeigen});
}
