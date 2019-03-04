import 'package:flutter/material.dart';
import 'package:questionnaire/src/screens/questionnaire_edit_screen.dart';
import 'package:questionnaire/src/widgets/custom_drawer.dart';
import 'package:questionnaire/src/widgets/exif_transform.dart';

class QuestionnaireListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaires'),
      ),
      body: Center(
        child: ExifTransform(child:Image.asset('images/f1.jpg'), exifOrientation: 6,),
      ),
      drawer: CustomDrawer(),
      floatingActionButton: buildFab(context),
    );
  }

  Widget buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return QuestionnaireEditScreen();
            },
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }
}
