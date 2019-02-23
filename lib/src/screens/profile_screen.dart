import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/screens/photo_viewer_screen.dart';
import 'package:intl/intl.dart';
import '../mixins/circular_profile_photo_builder.dart';

class ProfileScreen extends StatelessWidget with CircularProfilePhotoBuilder {
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
                  onPhotoTap(bloc, context);
                },
                child: buildProfilePhoto(bloc),
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

  void onPhotoTap(UserBloc bloc, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PhotoViewerScreen(
            url: bloc.lastUser.photoUrl,
          );
        },
      ),
    );
  }

  Widget buildCard(User user) {
    final dateFormatter = DateFormat('dd.MM.yy H:m');
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
