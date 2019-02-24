import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<FirebaseUser> verify(GlobalKey<ScaffoldState> scaffoldKey,
    Future<FirebaseUser> Function() submitAction) async {
  try {
    return await submitAction();
  } on PlatformException catch (e) {
    String message;
    switch (e.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        message = 'Email already in use.';
        break;
      case 'ERROR_INVALID_EMAIL':
        message = 'Enter valid email.';
        break;
      case 'ERROR_WRONG_PASSWORD':
        message = 'Password is wrong.';
        break;
      case 'ERROR_USER_NOT_FOUND':
        message = 'Email not found.';
        break;
      case 'ERROR_WEAK_PASSWORD':
        message = 'Password is too weak.';
        break;
      case 'ERROR_NETWORK_REQUEST_FAILED':
        message = 'Network request failed.';
        break;
      default:
        throw Exception('FirebaseAuthErrors enum exhausted: ${e.code}');
    }
    showSnackBar(scaffoldKey, message);
  } catch (e) {
    showSnackBar(scaffoldKey, 'Something wrong happen.');
    print(e);
  }

  return null;
}

void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}