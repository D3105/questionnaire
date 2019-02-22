import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/screens/questionnaire_list_screen.dart';
import 'package:questionnaire/src/screens/users_list_screen.dart';
import 'package:questionnaire/src/widgets/profile_photo.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = UserProvider.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildDrawerHeader(context, bloc),
          buildListTile(context, Icons.view_list, 'Questionnaires',
              Routes.questionnaireList, QuestionnaireListScreen),
          buildListTile(
              context, Icons.group, 'Users', Routes.usersList, UsersListScreen),
        ],
      ),
    );
  }

  Widget buildDrawerHeader(BuildContext context, UserBloc bloc) {
    return DrawerHeader(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, Routes.profile);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildProfilePhoto(bloc),
            SizedBox(height: 16),
            Text(
              bloc.lastUser.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
  }

  Widget buildProfilePhoto(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.profilePhoto,
      builder: (context, AsyncSnapshot<ProfilePhoto> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
          );
        }

        return snapshot.data;
      },
    );
  }

  Widget buildListTile(BuildContext context, IconData iconData, String title,
      String route, Type screenType) {
    return ListTile(
      title: Text(title),
      leading: Icon(iconData),
      onTap: () {
        Navigator.pop(context);
        final same = context.ancestorWidgetOfExactType(screenType) != null;
        if (!same) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
