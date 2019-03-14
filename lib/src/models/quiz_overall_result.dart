import 'package:cloud_firestore/cloud_firestore.dart';

class QuizOverallResult {
  int numberPassed;
  DocumentReference quizDocument;
  Map<String, Map<String, int>> alternativeData;

  QuizOverallResult(this.numberPassed, this.quizDocument, this.alternativeData);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (quizDocument != null) {
      map['quizId'] = quizDocument;
    }
    map['numberPassed'] = numberPassed;
    map['alternativeData'] = alternativeData;
  }

  QuizOverallResult.fromMap(Map<String, dynamic> map) {
    this.numberPassed = map['numberPassed'];
    this.quizDocument = map['quizId'];
    this.alternativeData = map['alternativeData'];
  }
}
