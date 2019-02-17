class Roles {
  static const student = Roles(0);
  static const teacher = Roles(1);
  static const dean = Roles(2);
  static const principal = Roles(3);

  final int rawValue;

  const Roles(this.rawValue);

  static const values = [student, teacher, dean, principal];

  @override
  String toString() {
    switch (this) {
      case Roles.student:
        return 'student';
      case Roles.teacher:
        return 'teacher';
      case Roles.dean:
        return 'dean';
      case Roles.principal:
        return 'principal';
      default:
        throw Exception('_Roles enum exhausted.');
    }
  }
}