import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/models/user.dart';
import '../mixins/authentication_fields.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State with AuthenticationFields {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Edit'),
        leading: buildIconButton(context, _Action.close),
        actions: <Widget>[
          buildIconButton(context, _Action.save),
        ],
      ),
      body: SingleChildScrollView(
        child: buildForm(),
      ),
    );
  }

  Widget buildForm() {
    if (role == null) {
      role = user.role;
    }

    return Container(
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
    );
  }

  IconButton buildIconButton(BuildContext context, _Action action) {
    switch (action) {
      case _Action.close:
        return IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      case _Action.save:
        return IconButton(
          icon: Icon(Icons.save),
          onPressed: isNameValid && isAboutValid
              ? () {
                  onSaved();
                }
              : null,
        );
      default:
        throw Exception('_Action enum exausted.');
    }
  }

  void onSaved() {
    user.name = nameController.text;
    user.role = role;
    user.about = aboutController.text;
    bloc.updateUser(UserType.primary, user);
    Navigator.pop(context);
  }
}

enum _Action { close, save }
