import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/helper/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Choice {
  const Choice({this.title});
  final String title;
  
}
const List<Choice> choices = const <Choice>[
  const Choice(title: 'Overall'),
  const Choice(title: 'Personal'),
  
];
class QuizResult extends StatelessWidget{
  
  Widget build(context){
    return DefaultTabController(
      length:2,
      child:Scaffold(appBar: AppBar(title: Text(
      "Quiz Results",
      ),actions: <Widget>[
        buildToQuizButton(context),buildPopupMenuButton(context)
            ],
            bottom: TabBar(isScrollable: true,tabs: <Widget>[
              Tab(text: "Overall",),
              Tab(text: "Personal"),
            ],),
            ),
            body:TabBarView(
              children: <Widget>[

              ],
            )
            ));
          }
        
        Widget buildPopupMenuButton(BuildContext context) {
            return PopupMenuButton(
              onSelected: (_) {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, Routes.signIn, (_) => false);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text('Sign out'),
                    value: 0,
                  )
                ];
              },
            );
          }
          //To-do: set link to quiz
          buildToQuizButton(BuildContext context) {
            return Navigator.pushNamed(context, '');
          }
}

