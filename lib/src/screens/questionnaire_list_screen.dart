import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:questionnaire/src/routes.dart';

class QuestionnaireListScreen extends StatelessWidget {
  final FirebaseUser user;

  QuestionnaireListScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaires'),
      ),
      body: Text('...'),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                user.email,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Questionnaires'),
              leading: Icon(Icons.view_list),
              onTap: () {
                Navigator.pop(context);
                print(this is! QuestionnaireListScreen);
                if (this is! QuestionnaireListScreen) {
                  Navigator.push(context, Routes.questionnaireList(user));
                }
              },
            ),
            ListTile(
              title: Text('Users'),
              leading: Icon(Icons.group),
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, Routes.questionnaireList);
              },
            ),
          ],
        ),
      ),
    );
  }
}
