import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/screens/photo_viewer_screen.dart';
import 'package:intl/intl.dart';
import '../mixins/circular_photo_builder.dart';

class ProfileScreen extends StatelessWidget with CircularPhotoBuilder {
  final UserType userType;

  ProfileScreen({Key key, this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: userType == UserType.primary
            ? <Widget>[
                buildEditAction(context),
                buildPopupMenuButton(context),
              ]
            : null,
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(UserBloc bloc) {
    final futureUser = Firestore.instance
        .document('/users/${bloc.lastUser(userType).uid}')
        .get();
    return FutureBuilder(
      future: futureUser,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final user = User.fromMap(snapshot.data.data);

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  onPhotoTap(user, context);
                },
                child: buildProfilePhoto(bloc.streamFor(userType)),
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

  void onPhotoTap(User user, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PhotoViewerScreen(
            url: user.photoUrl,
            userType: userType,
            photoType: PhotoType.userAvatar,
          );
        },
      ),
    );
  }

  Widget buildCard(User user) {
    final dateFormatter = DateFormat('dd.MM.yy HH:mm');
    final sinceDate = dateFormatter.format(user.since);
    return Card(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(user.name),
            Text(user.role),
            Text('Since: $sinceDate'),
            user.about.isEmpty
                ? Container(width: 0, height: 0)
                : Text('About: ${user.about}')
          ],
        ),
      ),
    );
  }

  Widget buildEditAction(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.pushNamed(
          context,
          Routes.profileEditScreen,
        );
      },
    );
  }

  Widget buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      onSelected: (_) {
        FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, Routes.signIn, (_) => false);
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
