import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/screens/base/base_modal_screen_state.dart';
import '../mixins/authentication_fields.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends BaseModalScreenState
    with AuthenticationFields {
  var isNameValid = true;
  var isAboutValid = true;

  String role;

  TextEditingController nameController;
  TextEditingController aboutController;

  UserBloc bloc;
  User user;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    bloc = UserProvider.of(context);
    user = bloc.lastUser(UserType.primary);

    nameController = TextEditingController(text: user.name);
    aboutController = TextEditingController(text: user.about);
  }

  @override
  Widget buildBody() {
    if (role == null) {
      role = user.role;
    }
    
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
            SizedBox(height: 16),
            buildRoleDropDown(
              role,
              (newRole) {
                role = newRole;
              },
            ),
            SizedBox(height: 16),
            buildAboutTextField(
              aboutController,
              isAboutValid,
              (isValid) {
                isAboutValid = isValid;
              },
            ),
          ],
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  void onSavePressed() {
    user.name = nameController.text;
    user.role = role;
    user.about = aboutController.text;
    bloc.updateUser(UserType.primary, user);
    Navigator.pop(context);
  }

  @override
  bool get isSaveEnabled => isNameValid && isAboutValid;

  @override
  String get title => 'Profile Edit';
}
