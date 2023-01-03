// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategorie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KategorieAdapter extends TypeAdapter<Kategorie> {
  @override
  final int typeId = 3;

  @override
  Kategorie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Kategorie(
      kategorie_id: fields[0] as int,
      kategorie: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Kategorie obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.kategorie_id)
      ..writeByte(1)
      ..write(obj.kategorie);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KategorieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
