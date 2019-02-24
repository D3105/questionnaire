import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/errors/authentication_errors.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/roles.dart';
import '../mixins/authentication_fields.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State with AuthenticationFields {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isProgressIndicatorOn = false;

  var isNameValid = true;
  var isAboutValid = true;
  var isEmailValid = true;
  var isPasswordValid = true;
  var isRetypePasswordValid = true;

  var role = Roles.student.description;

  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();

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
        buildNameTextField(
          nameController,
          isNameValid,
          (isValid) {
            isNameValid = isValid;
          },
        ),
        buildRoleDropDown(
          role,
          (newRole) {
            role = newRole;
          },
        ),
        buildAboutTextField(
          aboutController,
          isAboutValid,
          (isValid) {
            isAboutValid = isValid;
          },
        ),
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
            isRetypePasswordValid = false;
          },
        ),
        buildRetypePasswordTextField(
          retypePasswordController,
          isRetypePasswordValid,
          (password) {
            isRetypePasswordValid = (password == passwordController.text);
          },
        ),
        padding,
        buildSignUpButton(context),
        padding,
        buildSignInButton(context),
      ],
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return RaisedButton(
      child: isProgressIndicatorOn
          ? Container(
              child: CircularProgressIndicator(),
              height: 25,
              width: 25,
            )
          : Text('Sign Up'),
      onPressed: isNameValid &&
              isAboutValid &&
              isEmailValid &&
              isPasswordValid &&
              isRetypePasswordValid &&
              nameController.text.isNotEmpty &&
              emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty &&
              retypePasswordController.text.isNotEmpty
          ? () async {
              switchProgressIndicator();
              final futureFirebaseUser = verify(scaffoldKey, signUp);
              final firebaseUser = await futureFirebaseUser;
              if (firebaseUser != null) {
                Navigator.pushReplacementNamed(context, Routes.home);
              }
              switchProgressIndicator();
            }
          : null,
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return RaisedButton(
      child: Text('Sign In'),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.signIn);
      },
    );
  }

  Future<FirebaseUser> signUp() async {
    final name = nameController.text;
    final about = aboutController.text;
    final email = emailController.text;
    final password = passwordController.text;

    final user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await Firestore.instance.collection('users').document(user.uid).setData({
      'uid': user.uid,
      'name': name,
      'role': role,
      'about': about,
      'email': email,
      'since': FieldValue.serverTimestamp(),
      'color': Random().nextInt(Colors.primaries.length),
    });

    return user;
  }

  void switchProgressIndicator() {
    setState(() {
      isProgressIndicatorOn = !isProgressIndicatorOn;
    });
  }
}
