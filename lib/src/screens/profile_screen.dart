import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/widgets/profile_photo.dart';
import 'package:image_picker/image_picker.dart';
import '../helper/firebase_storage.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[buildPopupMenuButton(context)],
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(UserBloc bloc) {
    final futureUser =
        Firestore.instance.document('/users/${bloc.lastUser.uid}').get();
    return FutureBuilder(
      future: futureUser,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = User.fromMap(snapshot.data.data);

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  onPhotoTap(bloc);
                },
                child: buildPhoto(bloc),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: buildCard(user),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPhoto(UserBloc bloc) {
    return StreamBuilder<ProfilePhoto>(
      stream: bloc.profilePhoto,
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return snapshot.data;
      },
    );
  }

  void onPhotoTap(UserBloc bloc) async {
    final photo = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 200, maxHeight: 200);
    if (photo == null) return;
    bloc.pendingPhoto();
    final photoUrl = await uploadFile(photo, bloc.lastUser.uid);
    await Firestore.instance
        .document('/users/${bloc.lastUser.uid}')
        .updateData({'photoUrl': photoUrl});
    bloc.updatePhoto(file: photo);
  }

  Widget buildCard(User user) {
    final regDay = user.since.day;
    final regMonth = user.since.month;
    final regYear = user.since.year;
    return Card(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(user.name),
            Text(user.role),
            Text('Since: $regDay.$regMonth.$regYear'),
            user.about.isEmpty
                ? Container(width: 0, height: 0)
                : Text('About: ${user.about}')
          ],
        ),
      ),
    );
  }

  Widget buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      onSelected: (_) {
        FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.authentication, (_) => false);
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Text('Sign out'),
            value: 0,
          )
        ];
      },
    );
  }
}
