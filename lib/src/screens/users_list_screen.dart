import 'package:flutter/material.dart';
import 'package:questionnaire/src/widgets/custom_drawer.dart';

class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      drawer: CustomDrawer(),
    );
  }
}
