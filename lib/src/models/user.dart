import 'package:questionnaire/src/models/entity.dart';

class User extends Entity {
  String name;
  String role;
  String about;
  String email;
  String photoUrl;
  DateTime since;
  int color;

  User.fromMap(Map<String, dynamic> data)
      : name = data['name'],
        role = data['role'],
        about = data['about'],
        email = data['email'],
        photoUrl = data['photoUrl'],
        since = data['since'].toDate(),
        color = data['color'],
        super(uid: data['uid']);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'role': role,
      'about': about,
      'email': email,
      'photoUrl': photoUrl,
      'since': since,
      'color': color,
    };
  }
}
