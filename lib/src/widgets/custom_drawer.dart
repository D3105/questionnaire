import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:questionnaire/src/screens/profile_screen.dart';
import 'package:questionnaire/src/screens/questionnaire_list_screen.dart';
import 'package:questionnaire/src/screens/users_list_screen.dart';
import '../mixins/circular_photo_builder.dart';

class CustomDrawer extends StatelessWidget with CircularPhotoBuilder {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProfileScreen(
                  userType: UserType.primary,
                );
              },
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildProfilePhoto(bloc.streamFor(UserType.primary)),
            SizedBox(height: 16),
            Text(
              bloc.lastUser(UserType.primary).name,
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
