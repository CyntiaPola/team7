class Rezeptschritt{
  Rezeptschritt({required this.schritt, required this.zutat,
    required this.menge, required this.einheit,
    required this.zeit, required this.timerschritt, required this.wiegeschritt});
  String schritt;
  String zutat;
  String menge;
  String einheit;
  String zeit;
  bool wiegeschritt;
  bool timerschritt;
}