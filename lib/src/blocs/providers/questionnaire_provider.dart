import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/questionnaire_bloc.dart';
export 'package:questionnaire/src/blocs/questionnaire_bloc.dart';

class QuestionnaireProvider extends InheritedWidget {
  final bloc = QuestionnaireBloc.shared;

  QuestionnaireProvider({Key key, Widget child}) : super(key: key, child: child);

  static QuestionnaireBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(QuestionnaireProvider) as QuestionnaireProvider)
          .bloc;

  @override
  bool updateShouldNotify(_) => true;
}