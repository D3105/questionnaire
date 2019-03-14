import 'package:flutter/material.dart';
import 'dart:math';
import 'package:questionnaire/src/models/questionnaire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/models/quiz_overall_result.dart';
import 'package:questionnaire/src/widgets/spider_chart.dart';

class OverallQuestionnaireResult extends StatelessWidget {
  Firestore db;

  Questionnaire q;
  var quiz_id;

  @override
  Widget build(BuildContext context) {
    // final questionnaireBloc = QuestionnaireProvider.of(context);
    // final q = questionnaireBloc.last;
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('quiz_results_overall')
          .document('test')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final qObj = QuestionnaireOverallResult.fromMap(snapshot.data);

        return Column(
          children: <Widget>[
            SpiderChart(
                data: qObj.alternativeData.values.toList(),
                maxValue: qObj.alternativeData.values.reduce(max),
                colors: <Color>[
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                ],
                names: qObj.alternativeData.keys
                    .toList() //===============================================Добавить сюда результатов хуйни
                ),
            Scaffold(
              body: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." +
                  "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. " +
                  "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. " +
                  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
            ),
          ],
        );
      },
    );
  }
}
