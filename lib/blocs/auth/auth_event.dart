abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedInWithCode extends AuthEvent {
  final String code;
  LoggedInWithCode(this.code);
}

class LoggedOut extends AuthEvent {}
