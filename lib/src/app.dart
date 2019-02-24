import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/screens/home.dart';
import 'package:questionnaire/src/screens/profile_edit_screen.dart';
import 'package:questionnaire/src/screens/questionnaire_list_screen.dart';
import 'package:questionnaire/src/screens/sign_in_screen.dart';
import 'package:questionnaire/src/screens/sign_up_screen.dart';
import 'package:questionnaire/src/screens/users_list_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserProvider(
      child: MaterialApp(
        title: 'Questionnaire',
        routes: {
          Routes.home: (context) {
            return Home();
          },
          Routes.questionnaireList: (context) {
            return QuestionnaireListScreen();
          },
          Routes.usersList: (context) {
            return UsersListScreen();
          },
          Routes.profileEditScreen: (context) {
            return ProfileEditScreen();
          },
          Routes.signIn: (context) {
            return SignInScreen();
          },
          Routes.signUp: (context) {
            return SignUpScreen();
          },
        },
      ),
    );
  }
}
