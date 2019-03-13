import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/app.dart';
import 'package:questionnaire/src/screens/quiz_result_screen.dart';

Future<void> main() async {
  await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  runApp(App());
  // runApp(MaterialApp(home: QuizResultScreen()));
}
