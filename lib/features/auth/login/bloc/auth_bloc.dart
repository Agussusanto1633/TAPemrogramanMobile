import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_service.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    // Sign In with Google
    on<AuthSignInWithGoogle>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _authService.signInWithGoogle();
        emit(AuthSignedIn(userCredential.user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Sign In with Email
    on<AuthSignInWithEmail>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _authService.signInWithEmail(
          event.email,
          event.password,
        );
        emit(AuthSignedIn(userCredential.user!));
      } on FirebaseAuthException catch (e) {
        // Tangani berdasarkan error code
        if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
          emit(AuthError("Email atau password salah"));
        } else {
          emit(AuthError("Terjadi kesalahan: ${e.message}"));
        }
      } catch (e) {
        emit(AuthError("Terjadi kesalahan yang tidak diketahui."));
      }
    });

    // Register with Email
    on<AuthRegisterWithEmail>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _authService.registerWithEmail(
          event.email,
          event.password,
          displayName: event.displayName,
          noHp: event.noHp,
          photoURL: event.photoURL,
        );
        emit(AuthSignedIn(userCredential.user!));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          emit(AuthError("Format email tidak valid."));
        } else if (e.code == 'weak-password') {
          emit(AuthError("Password terlalu lemah (minimal 6 karakter)."));
        } else if (e.code == 'email-already-in-use') {
          emit(AuthError("Email sudah digunakan, silakan gunakan email lain."));
        } else {
          emit(AuthError("Terjadi kesalahan: ${e.message}"));
        }
      } catch (e) {
        emit(AuthError("Terjadi kesalahan yang tidak diketahui."));
      }
    });

    // Sign Out
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
