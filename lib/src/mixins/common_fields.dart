import 'package:flutter/material.dart';
import 'package:questionnaire/src/models/roles.dart';

mixin CommonFields on State {
  String getTrimmedText(TextEditingController controller) {
    return _trim(controller.text);
  }

  Widget buildNameTextField(
      TextEditingController controller, bool isValid, Function(bool) validate) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Name',
        errorText: isValid ? null : 'Name must contain from 5 to 31 chars.',
      ),
      onChanged: (name) {
        final trimmed = _trim(name);
        setState(() {
          validate(
            _checkLength(text: trimmed, min: 5, max: 31),
          );
        });
      },
    );
  }

  Widget buildAboutTextField(
      TextEditingController controller, bool isValid, Function(bool) validate) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'About',
        hintText: 'optional',
        errorText: isValid
            ? null
            : 'About must contain from 10 to 300 chars or be empty.',
      ),
      onChanged: (about) {
        final trimmed = _trim(about);
        setState(() {
          validate(
            _checkLength(text: trimmed, min: 10, max: 300, optional: true),
          );
        });
      },
    );
  }

  Widget buildEmailTextField(
      TextEditingController controller, bool isValid, Function(bool) validate) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: isValid ? null : 'Enter valid email.',
      ),
      onChanged: (email) {
        setState(() {
          validate(email.contains('@'));
        });
      },
    );
  }

  Widget buildPasswordTextField(
      TextEditingController controller, bool isValid, Function(bool) validate) {
    return TextField(
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: isValid ? null : 'Password must contain from 5 to 15 chars.',
      ),
      onChanged: (password) {
        setState(() {
          validate(password.length >= 5 && password.length <= 15);
        });
      },
    );
  }

  Widget buildRetypePasswordTextField(TextEditingController controller,
      bool isValid, Function(String) onChanged) {
    return TextField(
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Retype Password',
        errorText: isValid ? null : 'Password must be same.',
      ),
      onChanged: (password) {
        setState(() {
          onChanged(password);
        });
      },
    );
  }

  Widget buildRoleDropDown(String role, Function(String) onChanged) {
    final items = Roles.values.map(
      (role) {
        return DropdownMenuItem(
          child: Text(role.description),
          value: role.description,
        );
      },
    ).toList();
    return Container(
      child: DropdownButton<String>(
        items: items,
        value: role,
        onChanged: (role) {
          setState(() {
            onChanged(role);
          });
        },
        isExpanded: true,
        isDense: true,
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  String _trim(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _checkLength({String text, int min, int max, bool optional = false}) {
    final inRange = text.length >= min && text.length <= max;
    if (optional) {
      return inRange || text.isEmpty;
    }
    return inRange;
  }
}
