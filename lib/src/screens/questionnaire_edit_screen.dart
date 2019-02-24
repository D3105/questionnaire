import 'package:flutter/material.dart';
import 'package:questionnaire/src/screens/base/base_modal_screen_state.dart';
import '../mixins/authentication_fields.dart';

class QuestionnaireEditScreen extends StatefulWidget {
  @override
  _QuestionnaireEditScreenState createState() =>
      _QuestionnaireEditScreenState();
}

class _QuestionnaireEditScreenState extends BaseModalScreenState
    with AuthenticationFields {
  var isNameValid = true;
  var isAboutValid = true;

  final nameController = TextEditingController();
  final aboutController = TextEditingController();

  @override
  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            buildNameTextField(
              nameController,
              isNameValid,
              (isValid) {
                isNameValid = isValid;
              },
            ),
            buildAboutTextField(
              aboutController,
              isAboutValid,
              (isValid) {
                isAboutValid = isValid;
              },
            )
          ],
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  bool get isSaveEnabled =>
      isNameValid &&
      isAboutValid &&
      nameController.text.isNotEmpty;

  @override
  void onSavePressed() {
    Navigator.pop(context);
  }

  @override
  String get title => 'Add Questionnaire';
}