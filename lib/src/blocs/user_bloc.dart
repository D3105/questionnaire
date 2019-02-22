import 'dart:io';

import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/widgets/profile_photo.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  static final shared = UserBloc._();

  UserBloc._();

  final _userSubject = BehaviorSubject<User>();
  final _profilePhoto = BehaviorSubject<ProfilePhoto>();
  final _profilePhotoIsCircular = BehaviorSubject<bool>(seedValue: true);

  Observable<User> get user => _userSubject.stream;
  Observable<ProfilePhoto> get profilePhoto => _profilePhoto.stream;
  Observable<bool> get profilePhotoIsCircular => _profilePhotoIsCircular.stream;

  void updateUser(User user) {
    _userSubject.sink.add(user);
  }

  void updatePhoto({File file, String photoUrl}) {
    _profilePhoto.sink.add(
      ProfilePhoto(
        file: file,
        photoUrl: photoUrl,
      ),
    );
  }

  set photoIsCircular(bool circular) {
    _profilePhotoIsCircular.sink.add(circular);
  }

  void pendingPhoto() {
    _profilePhoto.sink.addError('pending photo');
  }

  User get lastUser => _userSubject.value;

  void dispose() {
    _userSubject.close();
    _profilePhoto.close();
    _profilePhotoIsCircular.close();
  }
}
