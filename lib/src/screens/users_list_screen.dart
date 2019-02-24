import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/blocs/user_bloc.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/screens/profile_screen.dart';
import 'package:questionnaire/src/widgets/custom_drawer.dart';
import 'package:questionnaire/src/widgets/profile_photo.dart';

class UsersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      drawer: CustomDrawer(),
      body: buildUsersList(context),
    );
  }

  Widget buildUsersList(BuildContext context) {
    final bloc = UserProvider.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data.documents.map(
            (document) {
              final user = User.fromMap(document.data);
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.role),
                leading: ProfilePhoto(
                  user: user,
                  radius: 25,
                ),
                onTap: () {
                  bloc.updateUser(UserType.current, user);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        final isPrimaryUser =
                            (user == bloc.lastUser(UserType.primary));
                        return ProfileScreen(
                          userType: isPrimaryUser
                              ? UserType.primary
                              : UserType.current,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ).toList(),
        );
      },
    );
  }
}
