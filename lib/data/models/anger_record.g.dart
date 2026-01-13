// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anger_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AngerRecordAdapter extends TypeAdapter<AngerRecord> {
  @override
  final int typeId = 0;

  @override
  AngerRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AngerRecord(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      intensityScore: fields[2] as int,
      trigger: fields[3] as String?,
      tags: (fields[4] as List?)?.cast<String>(),
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AngerRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.intensityScore)
      ..writeByte(3)
      ..write(obj.trigger)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AngerRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
