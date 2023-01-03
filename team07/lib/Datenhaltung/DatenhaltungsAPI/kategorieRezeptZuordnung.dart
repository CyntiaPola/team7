import 'package:hive/hive.dart';

part 'kategorieRezeptZuordnung.g.dart';

@HiveType(typeId: 4)
class KategorieRezeptZuordnung {
  @HiveField(0)
  int kr_zuordnung_id;

  @HiveField(1)
  int kategorie_id;

  @HiveField(2)
  int rezept_id;

  KategorieRezeptZuordnung(
      {required this.kr_zuordnung_id,
      required this.kategorie_id,
      required this.rezept_id});
}
