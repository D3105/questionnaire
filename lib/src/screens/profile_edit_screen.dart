import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/models/roles.dart';
import 'package:questionnaire/src/models/user.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
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
        child: buildForm(context),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    if (role == null) {
      role = user.role;
    }

    return Container(
      child: Column(
        children: <Widget>[
          buildNameTextField(),
          SizedBox(height: 16),
          buildRoleDropDown(),
          SizedBox(height: 16),
          buildAboutTextField(),
        ],
      ),
      margin: EdgeInsets.all(16),
    );
  }

  Widget buildNameTextField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        errorText: isNameValid ? null : 'Name must contain from 5 to 31 chars.',
      ),
      onChanged: (name) {
        setState(() {
          isNameValid = (name.length >= 5 && name.length <= 31);
        });
      },
    );
  }

  Widget buildAboutTextField() {
    return TextField(
      controller: aboutController,
      decoration: InputDecoration(
        labelText: 'About',
        errorText: isAboutValid
            ? null
            : 'About must contain from 10 to 300 chars or be empty.',
      ),
      onChanged: (about) {
        setState(() {
          isAboutValid = (about.length == 0 ||
              (about.length >= 10 && about.length <= 300));
        });
      },
    );
  }

  Widget buildRoleDropDown() {
    final items = Roles.values.map(
      (role) {
        return DropdownMenuItem(
          child: Text(role.description),
          value: role.description,
        );
      },
    ).toList();
    return DropdownButton<String>(
      items: items,
      value: role,
      onChanged: (role) {
        setState(() {
          this.role = role;
        });
      },
      isExpanded: true,
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
