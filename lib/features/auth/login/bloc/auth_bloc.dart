import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_service.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthSignInWithGoogle>((event, emit) async {
      emit(AuthLoading());

      try {
        final userCredential = await _authService.signInWithGoogle();
        emit(AuthSignedIn(userCredential.user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignOut>((event, emit) async {
      try {
        await _authService.signOut();
        emit(AuthSignedOut());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
