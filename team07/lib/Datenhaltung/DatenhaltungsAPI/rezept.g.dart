// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezept.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RezeptAdapter extends TypeAdapter<Rezept> {
  @override
  final int typeId = 6;

  @override
  Rezept read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rezept(
      rezept_id: fields[0] as int,
      titel: fields[1] as String,
      dauer: fields[2] as int,
      anspruch: fields[3] as int,
      bild: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Rezept obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.rezept_id)
      ..writeByte(1)
      ..write(obj.titel)
      ..writeByte(2)
      ..write(obj.dauer)
      ..writeByte(3)
      ..write(obj.anspruch)
      ..writeByte(4)
      ..write(obj.bild);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RezeptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
