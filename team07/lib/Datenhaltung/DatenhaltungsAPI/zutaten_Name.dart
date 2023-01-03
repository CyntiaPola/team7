import 'package:hive/hive.dart';

part 'zutaten_Name.g.dart';

@HiveType(typeId: 11)
class Zutaten_Name {
  @HiveField(0)
  int zutaten_name_id;

  @HiveField(1)
  String deutsch;

  @HiveField(2)
  String english;

  Zutaten_Name(
      {required this.zutaten_name_id,
      required this.deutsch,
      required this.english});
}
