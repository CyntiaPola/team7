

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'einkaufsliste.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EinkaufslisteAdapter extends TypeAdapter<Einkaufsliste> {
  @override
  final int typeId = 1;

  @override
  Einkaufsliste read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Einkaufsliste(
      einkaufsliste_id: fields[0] as int,
      zutatsname_id: fields[1] as int,
      rezept_id: fields[2] as int,
      menge: fields[3] as int,
      einheit: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Einkaufsliste obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.einkaufsliste_id)
      ..writeByte(1)
      ..write(obj.zutatsname_id)
      ..writeByte(2)
      ..write(obj.rezept_id)
      ..writeByte(3)
      ..write(obj.menge)
      ..writeByte(4)
      ..write(obj.einheit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EinkaufslisteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
