import 'package:flutter/material.dart';
import 'package:questionnaire/src/screens/questionnaire_list_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionnaire',
      home: QuestionnaireListScreen(),
    );
  }
}
