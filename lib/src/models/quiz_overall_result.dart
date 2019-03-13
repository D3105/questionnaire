class QuizOverallResultObject {
  int numberPassed;
  int quizId;
  Map<String, Map<String, int>> alternativeData;

  QuizOverallResultObject(this.numberPassed, this.quizId, this.alternativeData);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (quizId != null) {
      map['quizId'] = quizId;
    }
    map['numberPassed'] = numberPassed;
    map['alternativeData'] = alternativeData;
  }

  QuizOverallResultObject.fromMap(Map<String, dynamic> map) {
    this.numberPassed = map['numberPassed'];
    this.quizId = map['quizId'];
    this.alternativeData = map['alternativeData'];
  }
}
