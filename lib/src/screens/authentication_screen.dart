import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/authentication_provider.dart';
import 'package:questionnaire/src/errors/authentication_errors.dart';
import 'package:questionnaire/src/models/roles.dart';
import 'package:questionnaire/src/routes.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AuthenticationProvider.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 8),
              textField(TextFields.name, AuthenticationSubjects.name, bloc),
              SizedBox(height: 8),
              roleDropDown(bloc),
              SizedBox(height: 8),
              textField(TextFields.about, AuthenticationSubjects.about, bloc),
              SizedBox(height: 8),
              textField(TextFields.email, AuthenticationSubjects.email, bloc),
              SizedBox(height: 8),
              textField(
                  TextFields.password, AuthenticationSubjects.password, bloc),
              SizedBox(height: 8),
              textField(TextFields.retypePassword,
                  AuthenticationSubjects.retypePassword, bloc),
              SizedBox(height: 8),
              submitButton(bloc, SubmitButtons.signIn,
                  AuthenticationSubjects.signInIndicator),
              submitButton(bloc, SubmitButtons.signUp,
                  AuthenticationSubjects.signUpIndicator),
            ],
          ),
          margin: EdgeInsets.all(31),
        ),
      ),
    );
  }

  Widget textField(TextFields fieldType, AuthenticationSubjects subjectType,
      AuthenticationBloc bloc) {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return TextField(
          obscureText: fieldType.obscureText,
          decoration: InputDecoration(
            errorText: snapshot.error,
            labelText: fieldType.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.5),
            ),
          ),
          onChanged: (input) {
            bloc.add(subjectType, input);
          },
        );
      },
      stream: bloc.streamFor(subjectType),
    );
  }

  Widget roleDropDown(AuthenticationBloc bloc) {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        return Container(
          child: DropdownButton<Roles>(
            items: Roles.values
                .map(
                  (role) => DropdownMenuItem(
                        child: Text(role.toString()),
                        value: role,
                      ),
                )
                .toList(),
            value: snapshot.hasData ? snapshot.data : Roles.student,
            onChanged: (Roles role) {
              bloc.add(AuthenticationSubjects.role, role);
            },
            isExpanded: true,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.5),
            border: Border.all(
              width: 1,
              color: Colors.grey[600],
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        );
      },
      stream: bloc.streamFor(AuthenticationSubjects.role),
    );
  }

  Widget submitButton(AuthenticationBloc bloc, SubmitButtons buttonType,
      AuthenticationSubjects subjectType) {
    return StreamBuilder(
      builder: (context, snapshot) {
        return RaisedButton(
          child: Column(
            children: [
              Text(buttonType.toString()),
              authenticationIndicator(context, bloc, buttonType),
            ],
          ),
          onPressed: onSubmitButtonPressed(
              snapshot, buttonType, context, bloc, subjectType),
        );
      },
      stream: buttonType.allowedStream(bloc),
    );
  }

  Function onSubmitButtonPressed(
      AsyncSnapshot snapshot,
      SubmitButtons type,
      BuildContext context,
      AuthenticationBloc bloc,
      AuthenticationSubjects subjectType) {
    if (snapshot.hasData && snapshot.data) {
      return () async {
        final submitAction = type.submitAction(bloc);
        final futureUser = verify(context, submitAction, subjectType, bloc);
        bloc.add(subjectType, futureUser);
        final user = await futureUser;
        if (user != null) {
          Navigator.push(context, Routes.questionnaireList(user));
        }
      };
    }
    return null;
  }

  Widget authenticationIndicator(
      BuildContext context, AuthenticationBloc bloc, SubmitButtons type) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<FirebaseUser>(
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData && snapshot.data != null) {
                return Container(height: 0, width: 0);
              }
              return Container(
                child: LinearProgressIndicator(),
                width: 50,
              );
            },
            future: snapshot.data,
          );
        }
        return Container(height: 0, width: 0);
      },
      stream: type.indicatorStream(bloc),
    );
  }
}

class TextFields {
  static const name = TextFields._(
    0,
    'Name',
    false,
  );
  static const about = TextFields._(
    1,
    'About(optional)',
    false,
  );
  static const email = TextFields._(
    2,
    'Email',
    false,
  );
  static const password = TextFields._(
    3,
    'Password',
    true,
  );
  static const retypePassword = TextFields._(
    4,
    'Retype Password',
    true,
  );


  const TextFields._(this.rawValue, this.labelText, this.obscureText);

  final int rawValue;
  final String labelText;
  final bool obscureText;
}

class SubmitButtons {
  static const signIn = SubmitButtons._(0);
  static const signUp = SubmitButtons._(1);

  final int rawValue;

  const SubmitButtons._(this.rawValue);

  static const values = [signIn, signUp];

  Stream allowedStream(AuthenticationBloc bloc) {
    switch (this) {
      case SubmitButtons.signIn:
        return bloc.signInAllowed;
      case SubmitButtons.signUp:
        return bloc.signUpAllowed;
      default:
        throw Exception('SubmitButtons enum exhausted.');
    }
  }

  Stream indicatorStream(AuthenticationBloc bloc) {
    switch (this) {
      case SubmitButtons.signIn:
        return bloc.streamFor(AuthenticationSubjects.signInIndicator);
      case SubmitButtons.signUp:
        return bloc.streamFor(AuthenticationSubjects.signUpIndicator);
      default:
        throw Exception('SubmitButtons enum exhausted.');
    }
  }

  Function submitAction(AuthenticationBloc bloc) {
    switch (this) {
      case SubmitButtons.signIn:
        return bloc.signIn;
      case SubmitButtons.signUp:
        return bloc.signUp;
      default:
        throw Exception('SubmitButtons enum exhausted.');
    }
  }

  @override
  String toString() {
    switch (this) {
      case SubmitButtons.signIn:
        return 'Sign In';
      case SubmitButtons.signUp:
        return 'Sign Up';
      default:
        throw Exception('SubmitButtons enum exhausted.');
    }
  }
}
