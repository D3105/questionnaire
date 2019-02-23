import 'package:questionnaire/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  static final shared = UserBloc._();

  UserBloc._();

  final _userSubject = BehaviorSubject<User>();

  Observable<User> get user => _userSubject.stream;

  void updateUser(User user) {
    _userSubject.sink.add(user);
  }

  User get lastUser => _userSubject.value;

  void pendingPhoto() {
    _userSubject.sink.addError('pending photo');
  }

  void deletePhoto() {
    final user = lastUser;
    user.photoUrl = null;
    updateUser(user);
  }

  void dispose() {
    _userSubject.close();
  }
}
