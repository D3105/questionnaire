import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/models/entity.dart';

class QuestionnaireOverallResult extends Entity {
  int numberPassed;
  DocumentReference quizDocument;
  HashMap<String, int> alternativeData;

  QuestionnaireOverallResult(this.numberPassed, this.quizDocument, this.alternativeData);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (quizDocument != null) {
      map['quiz_Id'] = quizDocument;
    }
    map['people_Passed'] = numberPassed;
    map['results'] = alternativeData;
    return map;
  }

  QuestionnaireOverallResult.fromMap(Map<String, dynamic> map) {
    this.numberPassed = map['people_Passed'];
    this.quizDocument = map['quiz_Id'];
    this.alternativeData = new HashMap.from(map['results']);
  }
  
}
