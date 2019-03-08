import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/blocs/providers/questionnaire_provider.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/models/questionnaire.dart';
import 'package:questionnaire/src/screens/questionnaire_edit_screen.dart';
import 'package:questionnaire/src/widgets/custom_drawer.dart';

class QuestionnaireListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaires'),
      ),
      body: Center(
        child: buildQuestionnaireList(context),
      ),
      drawer: CustomDrawer(),
      floatingActionButton: buildFab(context),
    );
  }

  Widget buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return QuestionnaireEditScreen();
            },
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }

  Widget buildQuestionnaireList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('questionnaires').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            final questionnaire =
                Questionnaire.fromMap(snapshot.data.documents[index].data);
            return buildQuestionnaireTile(context, questionnaire);
          },
        );
      },
    );
  }

  Widget buildQuestionnaireTile(
      BuildContext context, Questionnaire questionnaire) {
    return ListTile(
      title: Text(questionnaire.name),
      subtitle: Text(questionnaire.about),
      leading: questionnaire.photoUrl != null
          ? CachedNetworkImage(
              imageUrl: questionnaire.photoUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(
                  radius: 25,
                  backgroundImage: imageProvider,
                );
              },
            )
          : SizedBox(height: 50, width: 50),
      onTap: () {
        onQuestionnaireTap(context, questionnaire);
      },
    );
  }

  void onQuestionnaireTap(BuildContext context, Questionnaire questionnaire) {
    final questionnaireBloc = QuestionnaireProvider.of(context);
    final userBloc = UserProvider.of(context);
    questionnaireBloc.update(questionnaire);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final isPrimaryUser = (questionnaire.creator.documentID ==
              userBloc.lastUser(UserType.primary).uid);
          throw 'TODO';
        },
      ),
    );
  }
}
