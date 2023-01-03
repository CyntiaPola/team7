// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategorieRezeptZuordnung.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KategorieRezeptZuordnungAdapter
    extends TypeAdapter<KategorieRezeptZuordnung> {
  @override
  final int typeId = 4;

  @override
  KategorieRezeptZuordnung read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KategorieRezeptZuordnung(
      kr_zuordnung_id: fields[0] as int,
      kategorie_id: fields[1] as int,
      rezept_id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, KategorieRezeptZuordnung obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.kr_zuordnung_id)
      ..writeByte(1)
      ..write(obj.kategorie_id)
      ..writeByte(2)
      ..write(obj.rezept_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KategorieRezeptZuordnungAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
