
abstract class AuthEvent {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  const LoginRequested(this.username, this.password);
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  const RegisterRequested(this.username, this.password);
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
