import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:page_transition/page_transition.dart';
import 'package:servista/core/nav_bar/nav_bar.dart';
import 'package:servista/core/nav_bar/admin_nav_bar.dart';

import '../../../auth/login/view/page/login_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  Future<void> _initialize() async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(milliseconds: 1));
    FlutterNativeSplash.remove();

    if (!mounted) return;

    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final isSeller = doc.data()?['isSeller'] ?? false;

      if (isSeller == true) {
        _navigate(child: const AdminNavBar());
      } else {
        _navigate(child: const NavBar());
      }
    } else {
      _navigate(child: const LoginPage());
    }
  }

  void _navigate({required Widget child}) {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(type: PageTransitionType.fade, child: child),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
