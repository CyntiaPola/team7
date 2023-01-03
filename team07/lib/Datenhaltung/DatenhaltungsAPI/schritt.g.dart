// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schritt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchrittAdapter extends TypeAdapter<Schritt> {
  @override
  final int typeId = 7;

  @override
  Schritt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schritt(
      schritt_id: fields[0] as int,
      schrittnummer: fields[1] as int,
      rezept_id: fields[2] as int,
      timer: fields[3] as int,
      waage: fields[4] as bool,
      beschreibung: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Schritt obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.schritt_id)
      ..writeByte(1)
      ..write(obj.schrittnummer)
      ..writeByte(2)
      ..write(obj.rezept_id)
      ..writeByte(3)
      ..write(obj.timer)
      ..writeByte(4)
      ..write(obj.waage)
      ..writeByte(5)
      ..write(obj.beschreibung);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchrittAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
