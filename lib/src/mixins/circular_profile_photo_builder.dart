import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/widgets/profile_photo.dart';

mixin CircularProfilePhotoBuilder {
    Widget buildProfilePhoto(UserBloc bloc) {
    return StreamBuilder<User>(
      stream: bloc.user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return ProfilePhoto(
          user: snapshot.data,
        );
      },
    );
  }
}