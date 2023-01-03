// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zutats_Menge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZutatsMengeAdapter extends TypeAdapter<Zutats_Menge> {
  @override
  final int typeId = 12;

  @override
  Zutats_Menge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zutats_Menge(
      zutats_Menge_id: fields[0] as int,
      rezept_id: fields[1] as int,
      schritt_id: fields[2] as int,
      zutaten_id: fields[3] as int,
      teilmenge: fields[4] as int,
      einheit: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Zutats_Menge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.zutats_Menge_id)
      ..writeByte(1)
      ..write(obj.rezept_id)
      ..writeByte(2)
      ..write(obj.schritt_id)
      ..writeByte(3)
      ..write(obj.zutaten_id)
      ..writeByte(4)
      ..write(obj.teilmenge)
      ..writeByte(5)
      ..write(obj.einheit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZutatsMengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
