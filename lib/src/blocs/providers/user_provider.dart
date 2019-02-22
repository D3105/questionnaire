import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/user_bloc.dart';
export 'package:questionnaire/src/blocs/user_bloc.dart';

class UserProvider extends InheritedWidget {
  final bloc = UserBloc.shared;

  UserProvider({Key key, Widget child}) : super(key: key, child: child);

  static UserBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserProvider) as UserProvider)
          .bloc;

  @override
  bool updateShouldNotify(_) => true;
}