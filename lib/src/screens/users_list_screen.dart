import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/blocs/user_bloc.dart';
import 'package:questionnaire/src/models/user.dart';
import 'package:questionnaire/src/screens/profile_screen.dart';
import 'package:questionnaire/src/widgets/custom_drawer.dart';
import 'package:questionnaire/src/widgets/profile_photo.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  Stream<QuerySnapshot> users;

  @override
  void initState() {
    super.initState();
    users = Firestore.instance.collection('users').snapshots();
  }

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
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            final user = User.fromMap(snapshot.data.documents[index].data);
            return buildUserTile(context, user);
          },
        );
      },
    );
  }

  Widget buildUserTile(BuildContext context, User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.role),
      leading: ProfilePhoto(
        user: user,
        radius: 25,
      ),
      onTap: () {
        onUserTap(context, user);
      },
    );
  }

  void onUserTap(BuildContext context, User user) {
    final bloc = UserProvider.of(context);
    bloc.updateUser(UserType.current, user);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final isPrimaryUser = (user == bloc.lastUser(UserType.primary));
          return ProfileScreen(
            userType: isPrimaryUser ? UserType.primary : UserType.current,
          );
        },
      ),
    );
  }
}
