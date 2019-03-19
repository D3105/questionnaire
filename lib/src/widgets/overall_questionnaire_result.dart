import 'package:flutter/material.dart';
import 'dart:math';
import 'package:questionnaire/src/models/questionnaire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/models/quiz_overall_result.dart';
import 'package:questionnaire/src/widgets/spider_chart.dart';

class OverallQuestionnaireResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final questionnaireBloc = QuestionnaireProvider.of(context);
    // final q = questionnaireBloc.last;
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('quiz_results_overall')
          .document('test')
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final qObj = QuestionnaireOverallResult.fromMap(snapshot.data.data);

        return Padding(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            child: Column(
              children: <Widget>[
                SpiderChart(
                    data: qObj.alternativeData.values.toList(),
                    maxValue: qObj.alternativeData.values.reduce(max) + 10,
                    //data:[8,3, 7, 5],
                    //maxValue: 10,
                    size: new Size(200, 200),
                    colors: <Color>[
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.yellow,
                    ],
                    names: qObj.alternativeData.keys
                        .toList() //===============================================Добавить сюда результатов хуйни
                    ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Scaffold(
                    body: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." +
                        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. " +
                        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. " +
                        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
                  ),
                ))
              ],
            ));
      },
    );
  }
}
