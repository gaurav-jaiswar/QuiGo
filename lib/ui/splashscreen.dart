import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz/ui/login_page.dart';
import 'package:quiz/utils/const.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});
  void navigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      Navigator.of(context).pushReplacementNamed(NavigatorConst.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigate(context);
    });
    return Scaffold(
      body: Center(
          child: Hero(tag: 'hero', child: Image.asset('assets/mylogo.png'))),
    );
  }
}
