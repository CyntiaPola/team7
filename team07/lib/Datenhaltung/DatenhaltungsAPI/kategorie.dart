import 'package:hive/hive.dart';

part 'kategorie.g.dart';

@HiveType(typeId: 3)
class Kategorie {
  @HiveField(0)
  int kategorie_id;

  @HiveField(1)
  String kategorie;

  Kategorie({required this.kategorie_id, required this.kategorie});
}
