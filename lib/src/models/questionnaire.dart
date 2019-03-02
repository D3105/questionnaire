import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questionnaire/src/models/entity.dart';

class Questionnaire extends Entity {
  String name;
  String about;
  String photoUrl;
  DateTime since;
  DocumentReference creator;

  Questionnaire.fromMap(Map<String, dynamic> data)
      : name = data['name'],
        about = data['about'],
        photoUrl = data['photoUrl'],
        since = data['since'],
        creator = data['creator'],
        super(uid: data['uid']);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'about': about,
      'photoUrl': photoUrl,
      'since': since,
      'creator': creator,
    };
  }
}
