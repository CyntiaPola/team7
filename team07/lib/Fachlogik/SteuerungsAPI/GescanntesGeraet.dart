import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class GescanntesGeraet{


  const GescanntesGeraet({
  required this.device,
  });

  final DiscoveredDevice device;


  String toString(){
    return device.name;
  }
}