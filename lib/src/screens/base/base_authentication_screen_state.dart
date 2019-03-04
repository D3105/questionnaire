import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/errors/authentication_errors.dart';
import 'package:questionnaire/src/helper/routes.dart';
import '../../mixins/common_fields.dart';

abstract class BaseAuthenticationScreenState extends State
    with CommonFields {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isProgressIndicatorOn = false;

  var isEmailValid = true;
  var isPasswordValid = true;

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

  Widget buildForm(BuildContext context);
  Future<FirebaseUser> authenticate();

  Widget buildPrimaryButton(
      BuildContext context, String title, bool isEnabled) {
    return RaisedButton(
      color: Colors.yellow,
      textColor: Colors.blue,
      child: isProgressIndicatorOn
          ? Container(
              child: CircularProgressIndicator(),
              height: 25,
              width: 25,
            )
          : Text(title),
      onPressed: isEnabled
          ? () async {
              switchProgressIndicator();
              final futureFirebaseUser = verify(scaffoldKey, authenticate);
              final firebaseUser = await futureFirebaseUser;
              if (firebaseUser != null) {
                Navigator.pushReplacementNamed(context, Routes.home);
              }
              switchProgressIndicator();
            }
          : null,
    );
  }

  Widget buildSecondaryButton(
      BuildContext context, String title, String route) {
    return OutlineButton(
      highlightColor: Colors.yellow,
      highlightedBorderColor: Colors.yellow,
      borderSide: BorderSide(color: Colors.yellow, width: 2),
      textColor: Colors.blue,
      child: Text(title),
      onPressed: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  void switchProgressIndicator() {
    setState(() {
      isProgressIndicatorOn = !isProgressIndicatorOn;
    });
  }

  Widget buildEmailField() {
    return buildEmailTextField(
      emailController,
      isEmailValid,
      (isValid) {
        isEmailValid = isValid;
      },
    );
  }
}
