class User {
  String uid;
  String name;
  String role;
  String about;
  String email;
  String photoUrl;
  DateTime since;
  int color;

  User.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        role = data['role'],
        about = data['about'],
        email = data['email'],
        photoUrl = data['photoUrl'],
        since = data['since'],
        color = data['color'];

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

  @override
  operator ==(dynamic object) {
    if (object.runtimeType != User) return false;
    return uid == object.uid;
  }

  @override
  int get hashCode => 31 + uid.hashCode;
}
