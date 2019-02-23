import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/user.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final futureFirebaseUser = FirebaseAuth.instance.currentUser();
    futureFirebaseUser.then(
      (firebaseUser) async {
        if (firebaseUser != null) {
          final userDocument = await Firestore.instance
              .document('/users/${firebaseUser.uid}')
              .get();
          final user = User.fromMap(userDocument.data);
          final userBloc = UserProvider.of(context);
          userBloc.updateUser(user);
          Navigator.pushReplacementNamed(
            context,
            Routes.questionnaireList,
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            Routes.authentication,
          );
        }
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Questionnaire',
              style: TextStyle(fontSize: 31),
            ),
            FutureBuilder(
              future: futureFirebaseUser,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container(width: 0, height: 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
