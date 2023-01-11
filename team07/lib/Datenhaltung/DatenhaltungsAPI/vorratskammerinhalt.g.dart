// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vorratskammerinhalt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VorratskammerinhaltAdapter extends TypeAdapter<Vorratskammerinhalt> {
  @override
  final int typeId = 9;

  @override
  Vorratskammerinhalt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vorratskammerinhalt(
      vorratskammerinhalt_id: fields[0] as int,
      zutatsname_id: fields[1] as int,
      menge: fields[2] as int,
      einheit: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vorratskammerinhalt obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.vorratskammerinhalt_id)
      ..writeByte(1)
      ..write(obj.zutatsname_id)
      ..writeByte(2)
      ..write(obj.menge)
      ..writeByte(3)
      ..write(obj.einheit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VorratskammerinhaltAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
