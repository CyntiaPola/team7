// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zutaten_Name.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZutatenNameAdapter extends TypeAdapter<Zutaten_Name> {
  @override
  final int typeId = 11;

  @override
  Zutaten_Name read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zutaten_Name(
      zutaten_name_id: fields[0] as int,
      deutsch: fields[1] as String,
      english: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Zutaten_Name obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.zutaten_name_id)
      ..writeByte(1)
      ..write(obj.deutsch)
      ..writeByte(2)
      ..write(obj.english);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZutatenNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
