import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/Bluetoothverbindung.dart';
import 'package:smart_waage/Fachlogik/SteuerungsAPI/GescanntesGeraet.dart';

import '../SteuerungsAPI/Verbindung.dart';

class Bluetoothverbindung_reactive_ble implements Bluetoothverbindung{




  late StreamSubscription<ConnectionStateUpdate> _connection;
  final devices = <DiscoveredDevice>[];
  int bluetoothzustand=0;

  final deviceVerbundenNotifier=ValueNotifier<bool>(false);


  final StreamController<GescanntesGeraet> _scanStateStreamController = StreamController.broadcast();
  final StreamController<Verbindung> _connectionStateStreamController = StreamController.broadcast();

  ///Objekt für den Aufbau der Bluetoothverbindung
  final FlutterReactiveBle _ble;


///Stream der ein beim Scannen gefundenes Gerät aufnimmt, wenn es unserer Waage entspricht
  Stream <GescanntesGeraet> get scanState => _scanStateStreamController.stream.asBroadcastStream();

  ///Stream der den Verbindungszustand eines verbundenen Geräts aufnimmt
  Stream <Verbindung> get connectionState => _connectionStateStreamController.stream.asBroadcastStream();

  ///Stream der Daten über den Bluetoothzustands des Geräts auf dem die App läuft aufnimmt
  Stream<BleStatus?> get state => _ble.statusStream.asBroadcastStream();

  ///Stream der Daten über die beim Scannen gefundenen Geräte aufnimmt
  StreamSubscription? _scanStream;

  Bluetoothverbindung_reactive_ble( {required FlutterReactiveBle ble,  })
   : _ble=ble;


  ///übernimmt [ bluetoothzustand ] als Objektattribut,
  ///
  /// sinnvolle Werte für [bluetoothzustand ] : 0 (noch nicht gescannt), 1 (gescannt) , 2 (verbunden)
  /// wird durch [bluetoothzustandHerstellen] verarbeitet
  void bluetoothzustandSetzen(int bluetoothzustand) {
    this.bluetoothzustand=bluetoothzustand;


  }


  ///Sendet je nach Wert von [bluetoothzustand] periodisch einen Wert mit dem aktuellen Verbindungsstatus
  ///an einen Stream, um die Widgetbuttons der Bluetoothsteuerung aktuell zu halten, auch wenn anzeigendes Menü
  ///geschlossen wird
  Future<void> bluetoothzustandHerstellen() async {


    if (bluetoothzustand==1){

      final stream = Stream<GescanntesGeraet>.periodic(
          const Duration(milliseconds: 200), (count) => GescanntesGeraet(device: devices[0])).take(2);
      await _scanStateStreamController.addStream(stream);
    }
    else if(bluetoothzustand==2){
      final stream = Stream<Verbindung>.periodic(
          const Duration(milliseconds: 200), (count) => Verbindung(connectionstate: ConnectionStateUpdate(deviceId: devices[0].id, connectionState: DeviceConnectionState.connected, failure: null))).take(2);
      await  _connectionStateStreamController.addStream(stream);


    }
  }








  ///Beendet die Bluetoothverbindung, löscht vorher gefundene Geräte und meldet Verbindungsabbruch
  ///per Streameintrag an
  @override
  Future<int> beenden() async {

    try {
      await _connection.cancel();
      _connectionStateStreamController.add(Verbindung(connectionstate: ConnectionStateUpdate(deviceId: devices[0].id, connectionState: DeviceConnectionState.disconnected, failure: null, )));

      deviceVerbundenNotifier.value = false;
    } on Exception catch (e, _) {
      return -1;
      "Beenden schiefgegangen";
    }
    finally{
      devices.clear();
    }

    return 0;
  }

  BleStatus status(){
    return _ble.status;

   }

  ///Scannt verfügbare BLE-Geräte und speichert Gerät mit Namen "Bluetooth-Waage", falls verfügbar
  void scannen() {

    devices.clear();
    _scanStream?.cancel();
    _scanStream =
        _ble.scanForDevices(withServices: []).listen((device) async {
          print(device.name);

          if (device.name=="Bluetooth-Waage") {
          //if (device.name=="Galaxy A3 (2017)") {
            devices.add(device);
            _scanStateStreamController.add(GescanntesGeraet(device: device));
            _scanStream?.cancel();

          }

        }, onError: (Object e) => -1);



  }



  ///Verbindet sich mit zuvor gescanntem Gerät "Bluetooth-Waage" und meldet erfolgreiche Verbindung
  ///in Form von Streameintrag an Listener
  @override
  Future<int> verbinden() async {

    int returnwert=0;





      _connection = _ble.connectToDevice(id: devices[0].id).listen(
              (update) {
                print(update.connectionState);


            if(update.connectionState==DeviceConnectionState.connected) {
              deviceVerbundenNotifier.value = true;
            }
            else if( update.connectionState==DeviceConnectionState.disconnected
            ){
              returnwert=- 1;
              return;

            }

            _connectionStateStreamController.add( Verbindung(connectionstate: update));
          },
          onError: (Object e) => print(e));











    return returnwert;

  }

  ///Meldet Geräte für Nachrichten der Waage an
  ///
  ///Service-ID und Characteristic-ID der Waage hier angegeben
  @override
  Stream<List<int>> datenEmpfangen()  {


    final characteristic = QualifiedCharacteristic(characteristicId: Uuid.parse("9a5d7e42-43c3-4e52-b0a2-7275084434bd"), serviceId: Uuid.parse("833b84e9-85cc-4b29-b232-fb021341964d"), deviceId: devices[0].id);
    //final characteristic = QualifiedCharacteristic(characteristicId: Uuid.parse("00002A19-0000-1000-8000-00805f9b34fb"), serviceId: Uuid.parse("0000180F-0000-1000-8000-00805f9b34fb"), deviceId: devices[0].id);


    return _ble.subscribeToCharacteristic(characteristic);


  }


  ///Führt Scannen, Verbunden und datenEmpfangen in einem Schritt aus, Verbinden wird solange wiederholt bis der Status "connected" ist
  Future<void> scannenVerbindenSubscribe()  async {
    scannen();

     int verbunden=0;
      Future.delayed(const Duration(seconds: 2), () async {verbunden = await verbinden() ;});
     while(verbunden!=0){
       Future.delayed(const Duration(seconds: 2), () async {verbunden = await verbinden() ;});
     }

    deviceVerbundenNotifier.value = true;

     await Future.delayed(const Duration(seconds: 5), (){datenEmpfangen();});
     int bluetoothzustand=2;



  }


  Future<void> dispose() async {
    await _scanStateStreamController.close();
    await _connectionStateStreamController.close();
  }


}

