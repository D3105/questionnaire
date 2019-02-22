class User {
  String uid;
  String name;
  String role;
  String about;
  String email;
  String photoUrl;
  DateTime since;

  User.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        role = data['role'],
        about = data['about'],
        email = data['email'],
        photoUrl = data['photoUrl'],
        since = data['since'];
}
