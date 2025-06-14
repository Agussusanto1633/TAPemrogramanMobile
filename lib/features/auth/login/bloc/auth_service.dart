import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception('Sign-in aborted');
    }

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    final user = userCredential.user;
    final uid = user!.uid;

    // Cek apakah user sudah ada di Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      // Kalau belum ada, tambahkan datanya
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'noHp': '', // Bisa diisi nanti via form update profil
        'isSeller': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Simpan ke SharedPreferences
    await _saveUserToPrefs(user);

    return userCredential;
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    try {

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // Fetch data tambahan dari Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = userDoc.data();

      if (userData != null) {
        final noHp = userData['noHp'];
        print("No HP pengguna: $noHp");
        await prefs.setString('user_phoneNumber', noHp);
      }

      await _saveUserToPrefs(credential.user);

      return credential;
    } on FirebaseAuthException catch (e) {
      print("ERROR CODE: ${e.code}");
      rethrow;
    }
  }


  Future<UserCredential> registerWithEmail(
      String email,
      String password, {
        required String displayName,
        required String noHp,
        String? photoURL,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      // Buat akun
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;

      if (user == null) {
        throw Exception("User creation failed.");
      }

      // Update profil (displayName dan photoURL)
      await user.updateDisplayName(displayName);
      if (photoURL != null && photoURL.isNotEmpty) {
        await user.updatePhotoURL(photoURL);
      }

      // Refresh data user
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      // Simpan data tambahan ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(updatedUser!.uid).set({
        'uid': updatedUser.uid,
        'email': updatedUser.email,
        'displayName': updatedUser.displayName,
        'noHp': noHp,
        'photoURL': updatedUser.photoURL ?? '',
        'isSeller': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Simpan ke SharedPreferences (dengan data yang sudah lengkap)
      await prefs.setString('user_phoneNumber', noHp);
      await _saveUserToPrefs(updatedUser);

      return credential;
    } on FirebaseAuthException catch (e) {
      print("ERROR CODE: ${e.code}"); // Tambahkan ini untuk debug
      rethrow;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      // Logout dari Firebase
      await FirebaseAuth.instance.signOut();

      // Logout dari Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // Hapus data user dari SharedPreferences
      await _clearUserFromPrefs();
      await prefs.clear();

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
  }

  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid');
    await prefs.remove('user_email');
    await prefs.remove('user_displayName');
    await prefs.remove('user_photoURL');
  }
}
