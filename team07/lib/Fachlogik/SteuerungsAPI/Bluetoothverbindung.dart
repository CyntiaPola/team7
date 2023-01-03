///Interface zur Steuerung der Bluetoothverbindung
abstract class Bluetoothverbindung{

  ///Scannt verfügbare BLE-Geräte und speichert Gerät mit Namen "Bluetooth-Waage", falls verfügbar
  void scannen();

  ///Verbindet sich mit zuvor gescanntem Gerät "Bluetooth-Waage" und meldet erfolgreiche Verbindung
  ///in Form von Streameintrag an Listener
  Future<int> verbinden();

  ///Beendet die Bluetoothverbindung, löscht vorher gefundene Geräte und meldet Verbindungsabbruch
  ///per Streameintrag an
  Future<int> beenden();

 ///Meldet Geräte für Nachrichten der Waage an
  ///
  ///Service-ID und Characteristic-ID der Waage hier angegeben
  Stream<List<int>> datenEmpfangen();

  ///Führt Scannen, Verbunden und datenEmpfangen in einem Schritt aus, Verbinden wird solange wiederholt bis der Status "connected" ist
  Future<void> scannenVerbindenSubscribe();

  ///übernimmt [ bluetoothzustand ] als Objektattribut,
  ///
  /// sinnvolle Werte für [bluetoothzustand ] : 0 (noch nicht gescannt), 1 (gescannt) , 2 (verbunden)
  /// wird durch [bluetoothzustandHerstellen] verarbeitet
  void bluetoothzustandSetzen(int bluetoothzustand);

  ///Sendet je nach Wert von [bluetoothzustand] periodisch einen Wert mit dem aktuellen Verbindungsstatus
  ///an einen Stream, um die Widgetbuttons der Bluetoothsteuerung aktuell zu halten, auch wenn anzeigendes Menü
  ///geschlossen wird
  Future<void> bluetoothzustandHerstellen();

}