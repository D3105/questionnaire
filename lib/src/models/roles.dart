class Roles {
  static const student = Roles('student');
  static const teacher = Roles('teacher');
  static const dean = Roles('dean');
  static const principal = Roles('principal');

  final String description;

  const Roles(this.description);

  static const values = [student, teacher, dean, principal];
}