class Vorratskammerinhalt_Anzeige {
  int vorratskammer_id;
  int zutatsname_id;
  String name;
  int menge;
  String einheit;

  Vorratskammerinhalt_Anzeige(
      {required this.vorratskammer_id,
      required this.zutatsname_id,
      required this.name,
      required this.menge,
      required this.einheit});
}
