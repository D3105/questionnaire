import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/authentication_provider.dart';
import 'package:questionnaire/src/screens/authentication_screen.dart';
import 'package:questionnaire/src/screens/questionnaire_list_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionnaire',
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return AuthenticationProvider(
          child: AuthenticationScreen(),
        );
      },
    );
  }
}
