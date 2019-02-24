import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/authentication_provider.dart';
import 'package:questionnaire/src/errors/authentication_errors.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/roles.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AuthenticationProvider.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: StreamBuilder(
              stream: bloc.streamFor(AuthenticationSubjects.submitButtonAction),
              initialData: SubmitButtons.signIn,
              builder: (context, snapshot) {
                List<Widget> children;
                switch (snapshot.data) {
                  case SubmitButtons.signIn:
                    children = signInColumnChildren(bloc);
                    break;
                  case SubmitButtons.signUp:
                    children = signUpColumnChildren(bloc);
                    break;
                  default:
                    throw Exception('SubmitButtons enum exhausted.');
                }

                return Column(
                  children: children,
                );
              },
            ),
            margin: EdgeInsets.all(31),
          ),
        ),
      ),
    );
  }

  List<Widget> signInColumnChildren(AuthenticationBloc bloc) {
    return <Widget>[
      SizedBox(height: 8),
      buildTextField(TextFields.email, AuthenticationSubjects.email, bloc),
      SizedBox(height: 8),
      buildTextField(
          TextFields.password, AuthenticationSubjects.password, bloc),
      SizedBox(height: 8),
      buildSubmitButton(
          bloc, SubmitButtons.signIn, AuthenticationSubjects.signInIndicator),
      SizedBox(height: 16),
      buildSubmitButton(
          bloc, SubmitButtons.signUp, AuthenticationSubjects.signUpIndicator),
    ];
  }

  List<Widget> signUpColumnChildren(AuthenticationBloc bloc) {
    return <Widget>[
      SizedBox(height: 8),
      buildTextField(TextFields.name, AuthenticationSubjects.name, bloc),
      SizedBox(height: 8),
      buildRoleDropDown(bloc),
      SizedBox(height: 8),
      buildTextField(TextFields.about, AuthenticationSubjects.about, bloc),
      SizedBox(height: 8),
      buildTextField(TextFields.email, AuthenticationSubjects.email, bloc),
      SizedBox(height: 8),
      buildTextField(
          TextFields.password, AuthenticationSubjects.password, bloc),
      SizedBox(height: 8),
      buildTextField(TextFields.retypePassword,
          AuthenticationSubjects.retypePassword, bloc),
      SizedBox(height: 8),
      buildSubmitButton(
          bloc, SubmitButtons.signUp, AuthenticationSubjects.signUpIndicator),
      SizedBox(height: 16),
      buildSubmitButton(
          bloc, SubmitButtons.signIn, AuthenticationSubjects.signInIndicator),
    ];
  }

  Widget buildTextField(TextFields fieldType,
      AuthenticationSubjects subjectType, AuthenticationBloc bloc) {
    return StreamBuilder(
      stream: bloc.streamFor(subjectType),
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
    );
  }

  Widget buildRoleDropDown(AuthenticationBloc bloc) {
    return StreamBuilder(
      stream: bloc.streamFor(AuthenticationSubjects.role),
      builder: (context, snapshot) {
        return Container(
          child: DropdownButton<Roles>(
            items: Roles.values.map(
              (role) {
                return DropdownMenuItem(
                  child: Text(role.description),
                  value: role,
                );
              },
            ).toList(),
            value: snapshot.data,
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
    );
  }

  Widget buildSubmitButton(AuthenticationBloc bloc, SubmitButtons buttonType,
      AuthenticationSubjects subjectType) {
    return StreamBuilder(
      builder: (context, snapshot) {
        return RaisedButton(
          child: Column(
            children: [
              Text(buttonType.description),
              buildAuthenticationIndicator(context, bloc, buttonType),
            ],
          ),
          onPressed: onSubmitButtonPressed(
              snapshot, buttonType, context, bloc, subjectType),
        );
      },
      stream: buttonType.enabledStream(bloc),
    );
  }

  Function onSubmitButtonPressed(
      AsyncSnapshot snapshot,
      SubmitButtons buttonType,
      BuildContext context,
      AuthenticationBloc bloc,
      AuthenticationSubjects subjectType) {
    final isPrimaryButton =
        (bloc.lastValue(AuthenticationSubjects.submitButtonAction) ==
            buttonType);
    if (!isPrimaryButton) {
      return () =>
          bloc.add(AuthenticationSubjects.submitButtonAction, buttonType);
    }

    if (snapshot.hasData &&
        (snapshot.data is! bool || (snapshot.data is bool && snapshot.data))) {
      return () async {
        final submitAction = buttonType.submitAction(bloc);
        final futureFirebaseUser =
            verify(context, submitAction, subjectType, bloc);
        bloc.add(subjectType, futureFirebaseUser);
        final firebaseUser = await futureFirebaseUser;
        if (firebaseUser != null) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      };
    }

    return null;
  }

  Widget buildAuthenticationIndicator(
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
  static const signIn = SubmitButtons._(0, 'Sign In');
  static const signUp = SubmitButtons._(1, 'Sign Up');

  final int rawValue;
  final String description;

  const SubmitButtons._(this.rawValue, this.description);

  static const values = [signIn, signUp];

  Stream enabledStream(AuthenticationBloc bloc) {
    return bloc.submitActionEnabled(this);
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
}
