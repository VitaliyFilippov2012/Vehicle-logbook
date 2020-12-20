import 'package:hive/hive.dart';

class PhotoBloc {
  LazyBox<dynamic> _box;

  Future<LazyBox<dynamic>> get box async {
    if (_box == null) {
      _box = await Hive.openLazyBox("PhotoModelBox");
    }
    return _box;
  }

  Future<String> getPhotoById(String id) async{
    var b = await box;
    return await b.get(id) as String;
  }

  Future<void> saveOrUpdateIfExists(String id, String photo) async{
    var b = await box;
    return await b.put(id, photo);
  }
}

PhotoBloc photoBloc = new PhotoBloc();
