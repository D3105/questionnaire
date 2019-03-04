import 'package:flutter/material.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/widgets/profile_photo.dart';
import 'package:rxdart/rxdart.dart';

mixin CircularProfilePhotoBuilder {
    Widget buildProfilePhoto(Observable<User> user) {
    return StreamBuilder<User>(
      stream: user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return ProfilePhoto(
          user: snapshot.data,
          radius: 50,
        );
      },
    );
  }
}