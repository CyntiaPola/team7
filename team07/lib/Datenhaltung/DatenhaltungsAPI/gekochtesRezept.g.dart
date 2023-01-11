// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gekochtesRezept.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GekochtesRezeptAdapter extends TypeAdapter<GekochtesRezept> {
  @override
  final int typeId = 2;

  @override
  GekochtesRezept read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GekochtesRezept(
      gekochtesRezept_ID: fields[0] as int,
      rezept_id: fields[1] as int,
      datum: fields[2] as dynamic,
      abgeschlossen: fields[3] as bool,
      naehrwert_id: fields[4] as int,
      status: fields[5] as int,
      portion: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, GekochtesRezept obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.gekochtesRezept_ID)
      ..writeByte(1)
      ..write(obj.rezept_id)
      ..writeByte(2)
      ..write(obj.datum)
      ..writeByte(3)
      ..write(obj.abgeschlossen)
      ..writeByte(4)
      ..write(obj.naehrwert_id)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.portion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GekochtesRezeptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
