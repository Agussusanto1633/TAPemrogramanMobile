import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:page_transition/page_transition.dart';
import 'package:servista/core/nav_bar/nav_bar.dart';

import '../../../auth/login/view/page/login_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  Future _initialize() async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(milliseconds: 100));
    FlutterNativeSplash.remove();

    if (mounted) {
      if (user != null) {
        _navigate(child: const NavBar());
      } else {
        _navigate(child: const LoginPage());
      }
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
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash/background.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
