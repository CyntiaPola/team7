// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dichte.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DichteAdapter extends TypeAdapter<Dichte> {
  @override
  final int typeId = 0;

  @override
  Dichte read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dichte(
      dichte_id: fields[0] as int,
      zutatsname_id: fields[1] as int,
      volumen_pro_100g: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Dichte obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dichte_id)
      ..writeByte(1)
      ..write(obj.zutatsname_id)
      ..writeByte(2)
      ..write(obj.volumen_pro_100g);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DichteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
