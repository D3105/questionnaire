import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/helper/firebase_storage.dart';
import 'package:questionnaire/src/models/questionnaire.dart';
import 'package:rxdart/rxdart.dart';

class QuestionnaireBloc {
  static final shared = QuestionnaireBloc._();

  QuestionnaireBloc._();

  final _questionnaireSubject = BehaviorSubject<Questionnaire>();

  Observable<Questionnaire> get questionnaire => _questionnaireSubject.stream;

  void update(Questionnaire questionnaire) async {
    _questionnaireSubject.sink.add(questionnaire);
    await Firestore.instance
        .document('/questionnaires/${questionnaire.uid}')
        .updateData(questionnaire.toMap());
  }

  Questionnaire get last => _questionnaireSubject.value;

  void pendingPhoto() {
    _questionnaireSubject.sink.addError('pending photo');
  }

  void deletePhoto() async {
    final questionnaire = last;
    questionnaire.photoUrl = null;
    update(questionnaire);
    deleteFile(questionnaire.uid);
  }

  void dispose() {
    _questionnaireSubject.close();
  }
}
