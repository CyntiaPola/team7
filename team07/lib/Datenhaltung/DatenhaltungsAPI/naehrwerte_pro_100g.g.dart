// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'naehrwerte_pro_100g.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Naehrwertepro100gAdapter extends TypeAdapter<Naehrwerte_pro_100g> {
  @override
  final int typeId = 5;

  @override
  Naehrwerte_pro_100g read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Naehrwerte_pro_100g(
      naehrwert_id: fields[0] as int,
      zutatsname_id: fields[1] as int,
      kcal: fields[2] as double,
      fett: fields[3] as double,
      gesaettigteFettsaeuren: fields[4] as double,
      zucker: fields[5] as double,
      eiweiss: fields[6] as double,
      salz: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Naehrwerte_pro_100g obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.naehrwert_id)
      ..writeByte(1)
      ..write(obj.zutatsname_id)
      ..writeByte(2)
      ..write(obj.kcal)
      ..writeByte(3)
      ..write(obj.fett)
      ..writeByte(4)
      ..write(obj.gesaettigteFettsaeuren)
      ..writeByte(5)
      ..write(obj.zucker)
      ..writeByte(6)
      ..write(obj.eiweiss)
      ..writeByte(7)
      ..write(obj.salz);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Naehrwertepro100gAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
