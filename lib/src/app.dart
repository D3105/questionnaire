import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/authentication_provider.dart';
import 'package:questionnaire/src/routes.dart';
import 'package:questionnaire/src/screens/authentication_screen.dart';
import 'package:questionnaire/src/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionnaire',
      home: Home(),
      routes: {
        Routes.authentication: (context) {
          return AuthenticationProvider(
            child: AuthenticationScreen(),
          );
        }
      },
    );
  }
}
