import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz/utils/const.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();

  void register() async {
    if (password.text.isEmpty ||
        confirmPassword.text.isEmpty ||
        userId.text.isEmpty ||
        name.text.isEmpty) {
      showErrorPopup(context, "Please enter all details");
      return;
    }
    if (password.text != confirmPassword.text) {
      showErrorPopup(
          context, "Enter same password in both password and confirm password");
      return;
    }
    showLoadingPopup(context, "Creating account...");
    try {
      await _auth.createUserWithEmailAndPassword(
          email: userId.text, password: password.text);
      await _auth.signInWithEmailAndPassword(
          email: userId.text, password: password.text);
      _auth.currentUser!.updateDisplayName(name.text);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId.text)
          .set({"name": name.text});
      Navigator.of(context).pop();
      Navigator.of(context).pushNamedAndRemoveUntil(NavigatorConst.home,
          (predicate) {
        return predicate.isFirst;
      });
      return;
    } catch (e) {
      print(e);
      showErrorPopup(context, e.toString());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: name,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: userId,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Email Id",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPassword,
              onSubmitted: (value) {
                register();
              },
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () {
                register();
                // userId.clear();
                // password.clear();
                // name.clear();
              },
              color: Colors.blueAccent,
              minWidth: double.maxFinite,
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
