import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/routes.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final futureUser = FirebaseAuth.instance.currentUser();
    futureUser.then(
      (user) {
        if (user != null) {
          Navigator.push(
            context,
            Routes.questionnaireList(user),
          );
        } else {
          Navigator.pushNamed(
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
              future: futureUser,
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
