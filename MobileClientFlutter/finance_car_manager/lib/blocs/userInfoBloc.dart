import 'package:finance_car_manager/blocs/carsBloc.dart';
import 'package:finance_car_manager/blocs/photoBloc.dart';
import 'package:finance_car_manager/db_context/managerDbContext.dart';
import 'package:finance_car_manager/db_context/sharedPreferencesRepository.dart';
import 'package:finance_car_manager/db_context/userRepository.dart';
import 'package:finance_car_manager/models/UserInfo.dart';
import 'package:finance_car_manager/synchronization/synchronization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class UserInfoBloc {
  final _repository = UserRepository();
  final _user = PublishSubject<UserInfo>();
  Stream<UserInfo> get userInfo => _user.stream;

  _asyncLoadFromServer() async {
    var preferences = SharedPreferencesRepository();
    var manager = ManagerDbContext();
    var status = await preferences.getStatusFromSharedPreferences();
    if (status == 'Offline') return;
    var sync = Synchronization();
    await sync.saveSyncDate();
    await sync.loadUserDataWithStaticInfo();
    await sync.loadUserCars();
    await sync.loadCarsEvents();
    await manager.createTriggers();
    carsBloc.getSelectedCarOrSetIfNotExistsInShared();
  }

  getUserInfo() async {
    var user = await _repository.getUser();
    if (user == null) {
      await _asyncLoadFromServer();
      user = await _repository.getUser();
    } else {
      setUserToStream(user);
      if (user.photo != null) {
        var photo = await photoBloc.getPhotoById(user.photo);
        user.photo = photo;
      }
      var sync = Synchronization();
      await sync.synchronizeProcess();
    }
  }

  void setUserToStream(UserInfo user) {
    _user.sink.add(user);
    _user.share();
  }

  dispose() {
    _user.close();
  }

  updateUserInfo(UserInfo user) async {
    if (user.photo != null) {
      var idPhoto = Uuid().v4().toString();
      photoBloc.saveOrUpdateIfExists(idPhoto, user.photo);
      user.photo = idPhoto;
    }
    _repository.updateUser(user);
    getUserInfo();
  }

  Future<UserInfo> getUser() {
    return _repository.getUser();
  }
}

final userInfoBloc = UserInfoBloc();
