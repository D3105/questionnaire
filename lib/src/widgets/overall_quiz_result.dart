import 'package:flutter/material.dart';

import 'package:questionnaire/src/blocs/providers/questionnaire_provider.dart';
import 'package:questionnaire/src/models/questionnaire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/models/quiz_overall_result.dart';
import 'package:questionnaire/src/widgets/spider_chart.dart';

class OverallQuizResult extends StatelessWidget {
  Firestore db;

  Questionnaire q;
  var quiz_id;

  @override
  Widget build(BuildContext context) {
    final questionnaireBloc = QuestionnaireProvider.of(context);
    q = questionnaireBloc.last;
    quiz_id = q.uid;
    return new StreamBuilder(
      stream: Firestore.instance
          .collection('quiz_results_overall')
          .document(quiz_id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text('Loading');
        }
        QuizOverallResultObject qObj = snapshot.data;
      },
    );

    return Column(
      children: <Widget>[
        SpiderChart(
          data: [3, 3, 4, 6],
          maxValue: 10,
          colors: <Color>[
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
          ],
          //names: q.,//===============================================Добавить сюда результатов хуйни
        )
      ],
    );
  }
}
