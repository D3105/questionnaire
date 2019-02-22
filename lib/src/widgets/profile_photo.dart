import 'dart:io';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';

class ProfilePhoto extends StatelessWidget {
  final String photoUrl;
  final File file;

  ProfilePhoto({Key key, this.photoUrl, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return StreamBuilder(
      stream: bloc.profilePhotoIsCircular,
      initialData: true,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: snapshot.data ? BoxShape.circle : BoxShape.rectangle,
            image: DecorationImage(
              image: image,
              fit: snapshot.data ? BoxFit.fill : BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  ImageProvider get image {
    if (file != null) {
      return FileImage(file);
    }
    if (photoUrl != null) {
      return NetworkImage(photoUrl);
    }
    return AssetImage('images/default_profile_photo.png');
  }
}
