abstract class AuthEvent {}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthSignOut extends AuthEvent {}

class AuthSignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  AuthSignInWithEmail({
    required this.email,
    required this.password,
  });
}

class AuthRegisterWithEmail extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  final String noHp;
  final String? photoURL;

  AuthRegisterWithEmail({
    required this.email,
    required this.password,
    required this.displayName,
    required this.noHp,
    this.photoURL,
  });
}
