// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zutaten.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZutatenAdapter extends TypeAdapter<Zutaten> {
  @override
  final int typeId = 10;

  @override
  Zutaten read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zutaten(
      zutaten_id: fields[0] as int,
      name_id: fields[1] as int,
      rezept_id: fields[2] as int,
      naehrwert_id: fields[3] as int,
      menge_pp: fields[4] as int,
      einheit: fields[5] as String,
      volumen_id: fields[6] as int,
      masse_id: fields[7] as int,
      dichte_id: fields[8] as int,
      skalierbar: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Zutaten obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.zutaten_id)
      ..writeByte(1)
      ..write(obj.name_id)
      ..writeByte(2)
      ..write(obj.rezept_id)
      ..writeByte(3)
      ..write(obj.naehrwert_id)
      ..writeByte(4)
      ..write(obj.menge_pp)
      ..writeByte(5)
      ..write(obj.einheit)
      ..writeByte(6)
      ..write(obj.volumen_id)
      ..writeByte(7)
      ..write(obj.masse_id)
      ..writeByte(8)
      ..write(obj.dichte_id)
      ..writeByte(9)
      ..write(obj.skalierbar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZutatenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
