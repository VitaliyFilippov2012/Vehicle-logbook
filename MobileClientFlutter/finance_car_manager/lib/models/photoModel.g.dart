// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photoModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoModelAdapter extends TypeAdapter<PhotoModel> {
  @override
  PhotoModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoModel()
      ..idPhoto = fields[0] as String
      ..photo = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, PhotoModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.idPhoto)
      ..writeByte(1)
      ..write(obj.photo);
  }

  @override
  // TODO: implement typeId
  int get typeId => throw UnimplementedError();
}
