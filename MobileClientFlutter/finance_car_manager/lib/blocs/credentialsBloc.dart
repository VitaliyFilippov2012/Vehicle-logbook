import 'package:finance_car_manager/db_context/userRepository.dart';
import 'package:finance_car_manager/models/userCredentials.dart';
import 'package:rxdart/rxdart.dart';

class CredentialsBloc {
  final _repository = UserRepository();
  final _credentials = PublishSubject<UserCredentials>();

  Stream<UserCredentials> get savedCred => _credentials.stream;

  getSaveCred() async {
    var credentias = await _repository.checkKeepCredentials();
    
    _credentials.sink.add(credentias);
  }

  dispose() {
    _credentials.close();
  }
}

final credentialsBloc = CredentialsBloc();
