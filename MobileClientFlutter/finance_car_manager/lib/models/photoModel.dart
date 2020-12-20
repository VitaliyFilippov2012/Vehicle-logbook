import 'package:hive/hive.dart';

part 'photoModel.g.dart';

@HiveType()
class PhotoModel{
  @HiveField(0)
  String idPhoto;
  
  @HiveField(1)
  String photo;
}