abstract class Entity {
  final String uid;

  Entity({this.uid});

  @override
  operator ==(dynamic object) {
    if (object is! Entity) return false;
    return uid == object.uid;
  }

  @override
  int get hashCode => 31 + uid.hashCode;
}
