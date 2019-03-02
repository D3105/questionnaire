import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/helper/firebase_storage.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  static final shared = UserBloc._();
  var _subjects = Map<UserType, BehaviorSubject<User>>();

  UserBloc._() {
    for (final type in UserType.values) {
      _subjects[type] = BehaviorSubject();
    }
  }

  Observable<User> streamFor(UserType type) {
    return _subjects[type].stream;
  }

  void updateUser(UserType type, User user) async {
    _subjects[type].sink.add(user);
    await Firestore.instance
        .document('/users/${user.uid}')
        .updateData(user.toMap());
  }

  User lastUser(UserType type) {
    return _subjects[type].value;
  }

  pendingPhoto(UserType type) {
    _subjects[type].sink.addError('pending photo');
  }

  deletePhoto(UserType type) async {
    final user = lastUser(type);
    user.photoUrl = null;
    updateUser(type, user);
    deleteFile(user.uid);
  }

  void dispose() {
    _subjects.values.forEach((subject) {
      subject.close();
    });
  }
}

enum UserType { primary, current }
