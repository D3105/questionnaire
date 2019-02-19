import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/authentication_bloc.dart';
export 'package:questionnaire/src/blocs/authentication_bloc.dart';

class AuthenticationProvider extends InheritedWidget {
  final bloc = AuthenticationBloc.shared;

  AuthenticationProvider({Key key, Widget child})
      : super(key: key, child: child);

  static AuthenticationBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AuthenticationProvider)
              as AuthenticationProvider)
          .bloc;

  @override
  bool updateShouldNotify(_) => true;
}
