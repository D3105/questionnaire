import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationBloc {
  final _subjects = Map<AuthenticationSubjects, BehaviorSubject>();

  AuthenticationBloc() {
    for (final type in AuthenticationSubjects.values) {
      _subjects[type] = BehaviorSubject();

      if (type == AuthenticationSubjects.about) {
        add(AuthenticationSubjects.about, '');
      }
    }
  }

  Future<FirebaseUser> signIn() async {
    final email = _subjects[AuthenticationSubjects.email].value;
    final password = _subjects[AuthenticationSubjects.password].value;
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> signUp() {
    final inputs = AuthenticationSubjects.values
        .map((input) => _subjects[input].value)
        .toList();
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: inputs[3], password: inputs[4]);
  }

  Observable<bool> get signInAllowed => Observable.combineLatest2(
        streamFor(AuthenticationSubjects.email),
        streamFor(AuthenticationSubjects.password),
        (e, p) {
          return true;
        },
      );

  Observable<bool> get signUpAllowed => Observable.combineLatest5(
          streamFor(AuthenticationSubjects.name),
          streamFor(AuthenticationSubjects.about),
          streamFor(AuthenticationSubjects.email),
          streamFor(AuthenticationSubjects.password),
          streamFor(AuthenticationSubjects.retypePassword),
          (name, about, email, password, retypePassword) {
        if (password == retypePassword) {
          return true;
        }
        _subjects[AuthenticationSubjects.retypePassword]
            .sink
            .addError('Password must be same.');
        return false;
      });

  Stream streamFor(AuthenticationSubjects type) {
    return _subjects[type].transform(type.transformer);
  }

  void add(AuthenticationSubjects type, value) {
    _subjects[type].sink.add(value);
  }

  void addError(AuthenticationSubjects type, error) {
    _subjects[type].sink.addError(error);
  }

  void dispose() {
    _subjects.values.forEach((c) => c.close());
  }
}

class AuthenticationSubjects {
  static final name = AuthenticationSubjects._(
    0,
    _createTransformer(
      filter: (name) => name.length >= 5 && name.length <= 31,
      error: 'Name must contain from 5 to 31 chars.',
    ),
  );
  static final role = AuthenticationSubjects._(
    1,
    _createTransformer(
      filter: (role) => true,
      error: '',
    ),
  );
  static final about = AuthenticationSubjects._(
    2,
    _createTransformer(
      filter: (about) =>
          about.length == 0 || (about.length >= 10 && about.length <= 300),
      error: 'About must contain from 10 to 300 chars.',
    ),
  );
  static final email = AuthenticationSubjects._(
    3,
    _createTransformer(
      filter: (email) => email.contains('@'),
      error: 'Enter valid email.',
    ),
  );
  static final password = AuthenticationSubjects._(
    4,
    _createTransformer(
      filter: (password) => password.length >= 5 && password.length <= 15,
      error: 'Password must contain from 5 to 15 chars.',
    ),
  );
  static final retypePassword = AuthenticationSubjects._(
    5,
    _createTransformer(
      filter: (password) => password.length >= 5 && password.length <= 15,
      error: 'Password must contain from 5 to 15 chars.',
    ),
  );
  static final signInIndicator = AuthenticationSubjects._(
    6,
    _createTransformer(
      filter: (_) => true,
      error: '',
    ),
  );
  static final signUpIndicator = AuthenticationSubjects._(
    7,
    _createTransformer(
      filter: (_) => true,
      error: '',
    ),
  );

  static final values = [name, role, about, email, password, retypePassword, signInIndicator, signUpIndicator];

  final int rawValue;
  final StreamTransformer transformer;

  AuthenticationSubjects._(this.rawValue, this.transformer);
}

StreamTransformer _createTransformer(
    {bool Function(dynamic) filter, String error}) {
  return StreamTransformer.fromHandlers(handleData: (data, sink) {
    if (filter(data)) {
      sink.add(data);
    } else {
      sink.addError(error);
    }
  });
}
