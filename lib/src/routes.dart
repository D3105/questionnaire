import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/screens/questionnaire_list_screen.dart';

class Routes {
  static const authentication = '/authentication';
  static MaterialPageRoute questionnaireList(FirebaseUser user) {
    return MaterialPageRoute(
      builder: (context) {
        return QuestionnaireListScreen(user: user);
      },
    );
  }
}
