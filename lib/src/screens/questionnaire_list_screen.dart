import 'package:flutter/material.dart';
import 'package:questionnaire/src/widgets/custom_drawer.dart';

class QuestionnaireListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaires'),
      ),
      body: Text('...'),
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
