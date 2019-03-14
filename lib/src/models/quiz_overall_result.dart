import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/models/entity.dart';

class QuestionnaireOverallResult extends Entity {
  int numberPassed;
  DocumentReference quizDocument;
  Map<String, int> alternativeData;

  QuestionnaireOverallResult(this.numberPassed, this.quizDocument, this.alternativeData);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (quizDocument != null) {
      map['quizId'] = quizDocument;
    }
    map['numberPassed'] = numberPassed;
    map['alternativeData'] = alternativeData;
    return map;
  }

  QuestionnaireOverallResult.fromMap(Map<String, dynamic> map) {
    this.numberPassed = map['numberPassed'];
    this.quizDocument = map['quizId'];
    this.alternativeData = map['alternativeData'];
  }
}
