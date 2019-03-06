import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/models/roles.dart';
import 'package:questionnaire/src/screens/base/base_authentication_screen_state.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseAuthenticationScreenState {
  var isNameValid = true;
  var isAboutValid = true;
  var isRetypePasswordValid = true;

  var role = Roles.student.description;

  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final retypePasswordController = TextEditingController();

  @override
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
        buildEmailField(),
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
        buildPrimaryButton(
          context,
          'Sign Up',
          isNameValid &&
              isAboutValid &&
              isEmailValid &&
              isPasswordValid &&
              isRetypePasswordValid &&
              nameController.text.isNotEmpty &&
              emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty &&
              retypePasswordController.text.isNotEmpty,
        ),
        padding,
        buildSecondaryButton(context, 'Sign In', Routes.signIn),
      ],
    );
  }

  @override
  Future<FirebaseUser> authenticate() async {
    final name = getTrimmedText(nameController);
    final about = getTrimmedText(aboutController);
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
}