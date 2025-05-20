import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception('Sign-in aborted');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Simpan data user ke SharedPreferences
    await _saveUserToPrefs(userCredential.user);

    return userCredential;
  }

  Future<void> signOut() async {
    try {
      // Logout dari Firebase
      await FirebaseAuth.instance.signOut();

      // Logout dari Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // Hapus data user dari SharedPreferences
      await _clearUserFromPrefs();

      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _saveUserToPrefs(User? user) async {
    if (user == null) return;
    final prefs = await SharedPreferences.getInstance();

    // Simpan informasi yang kamu mau, contoh:
    await prefs.setString('user_uid', user.uid);
    await prefs.setString('user_email', user.email ?? '');
    await prefs.setString('user_displayName', user.displayName ?? '');
    await prefs.setString('user_photoURL', user.photoURL ?? '');
    await prefs.setString('user_phoneNumber', user.phoneNumber ?? '');
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid');
    await prefs.remove('user_email');
    await prefs.remove('user_displayName');
    await prefs.remove('user_photoURL');
  }
}
