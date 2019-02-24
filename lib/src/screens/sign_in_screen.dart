import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/screens/base/base_authentication_screen_state.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends BaseAuthenticationScreenState {
  @override
  Widget buildForm(BuildContext context) {
    return Column(
      children: <Widget>[
        buildEmailField(),
        buildPasswordTextField(
          passwordController,
          isPasswordValid,
          (isValid) {
            isPasswordValid = isValid;
          },
        ),
        padding,
        buildPrimaryButton(
          context,
          'Sign In',
          isEmailValid &&
              isPasswordValid &&
              emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty,
        ),
        padding,
        buildSecondaryButton(context, 'Sign Up', Routes.signUp),
      ],
    );
  }

  @override
  Future<FirebaseUser> authenticate() async {
    final email = emailController.text;
    final password = passwordController.text;
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}