import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:questionnaire/src/blocs/providers/questionnaire_provider.dart';
import 'package:questionnaire/src/blocs/providers/user_provider.dart';
import 'package:questionnaire/src/models/questionnaire.dart';

class QuestionnaireDetailScreen extends StatefulWidget {
  final bool isPrimaryUser;

  const QuestionnaireDetailScreen({Key key, this.isPrimaryUser})
      : super(key: key);

  @override
  _QuestionnaireDetailScreenState createState() =>
      _QuestionnaireDetailScreenState();
}

class _QuestionnaireDetailScreenState extends State<QuestionnaireDetailScreen> {
  Stream<DocumentSnapshot> questionnaireStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = QuestionnaireProvider.of(context);
    final questionnaire = bloc.last;
    questionnaireStream = Firestore.instance
        .document('questionnaires/${questionnaire.uid}')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire Detail'),
        actions: buildAppBarActions(),
      ),
      floatingActionButton: buildFab(),
      body: buildBody(),
      bottomSheet: buildBottomSheet(),
    );
  }

  Widget buildBody() {
    return StreamBuilder(
      stream: questionnaireStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final questionnaire = Questionnaire.fromMap(snapshot.data.data);
        return Column(
          children: <Widget>[
            questionnaire.photoUrl != null
                ? buildPhotoView(questionnaire)
                : null,
            buildTitle(questionnaire),
            buildQuestionnaireBody(questionnaire),
            buildSubtitle(questionnaire)
          ],
        );
      },
    );
  }

  Widget buildBottomSheet() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Comments',
              style: TextStyle(fontSize: 19),
            ),
          ),
        ],
      ),
      height: 50,
    );
  }

  Widget buildFab() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              throw 'TODO';
            },
          ),
        );
      },
      child: Icon(Icons.assignment),
    );
  }

  List<Widget> buildAppBarActions() {
    var actions = <Widget>[
      IconButton(
        icon: Icon(Icons.assessment),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                throw 'TODO';
              },
            ),
          );
        },
      ),
    ];

    if (widget.isPrimaryUser) {
      actions.add(buildPopupMenuButton());
    }

    return actions;
  }

  Widget buildPopupMenuButton() {
    return PopupMenuButton(
      onSelected: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              throw 'TODO';
            },
          ),
        );
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text('Edit'),
            value: 0,
          ),
        ];
      },
    );
  }

  Widget buildPhotoView(Questionnaire questionnaire) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: questionnaire.photoUrl,
          imageBuilder: (context, imageProvider) {
            return Image(image: imageProvider);
          },
          placeholder: (context, photoUrl) {
            return CircularProgressIndicator();
          },
        ),
        Positioned(
          child: Icon(Icons.done),
          bottom: 16,
          right: 16,
        ),
      ],
    );
  }

  Widget buildTitle(Questionnaire questionnaire) {
    return Center(child: Text(questionnaire.name));
  }

  Widget buildQuestionnaireBody(Questionnaire questionnaire) {
    return Row(
      children: <Widget>[
        buildRatingWidget(questionnaire),
        Text(questionnaire.about),
      ],
    );
  }

  Widget buildRatingWidget(Questionnaire questionnaire) {
    return Column(
      children: <Widget>[
        Text('31'),
        IconButton(
          icon: Icon(Icons.thumb_up),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildSubtitle(Questionnaire questionnaire) {
    final bloc = UserProvider.of(context);
    final creator = bloc.lastUser(UserType.current);

    final dateFormatter = DateFormat('dd.MM.yy HH:mm');
    final date = dateFormatter.format(questionnaire.since);

    return Row(
      children: <Widget>[
        Text(creator.name),
        Text(date),
      ],
    );
  }
}
