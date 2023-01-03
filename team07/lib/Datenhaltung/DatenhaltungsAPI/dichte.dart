import 'package:hive/hive.dart';

part 'dichte.g.dart';

@HiveType(typeId: 0)
class Dichte {
  @HiveField(0)
  int dichte_id;

  @HiveField(1)
  int zutatsname_id;

  @HiveField(2)
  double volumen_pro_100g;

  Dichte(
      {required this.dichte_id,
      required this.zutatsname_id,
      required this.volumen_pro_100g});
}
