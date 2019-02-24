import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/errors/authentication_errors.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/roles.dart';
import '../mixins/authentication_fields.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State with AuthenticationFields {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isProgressIndicatorOn = false;

  var isEmailValid = true;
  var isPasswordValid = true;

  var role = Roles.student.description;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: buildForm(context),
            margin: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget get padding => SizedBox(height: 8);

  Widget buildForm(BuildContext context) {
    return Column(
      children: <Widget>[
        buildEmailTextField(
          emailController,
          isEmailValid,
          (isValid) {
            isEmailValid = isValid;
          },
        ),
        buildPasswordTextField(
          passwordController,
          isPasswordValid,
          (isValid) {
            isPasswordValid = isValid;
          },
        ),
        padding,
        buildSignInButton(context),
        padding,
        buildSignUpButton(context),
      ],
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return RaisedButton(
      child: isProgressIndicatorOn
          ? Container(
              child: CircularProgressIndicator(),
              height: 25,
              width: 25,
            )
          : Text('Sign In'),
      onPressed: isEmailValid &&
              isPasswordValid &&
              emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty
          ? () async {
              switchProgressIndicator();
              final futureFirebaseUser = verify(scaffoldKey, signIn);
              final firebaseUser = await futureFirebaseUser;
              if (firebaseUser != null) {
                Navigator.pushReplacementNamed(context, Routes.home);
              }
              switchProgressIndicator();
            }
          : null,
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return RaisedButton(
      child: Text('Sign Up'),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.signUp);
      },
    );
  }

  Future<FirebaseUser> signIn() async {
    final email = emailController.text;
    final password = passwordController.text;
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  void switchProgressIndicator() {
    setState(() {
      isProgressIndicatorOn = !isProgressIndicatorOn;
    });
  }
}
