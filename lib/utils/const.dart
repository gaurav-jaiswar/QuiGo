import 'package:flutter/material.dart';

class NavigatorConst {
  static const String home = '/';
  static const String login = 'login';
  static const String quiz = 'quiz';
  static const String splash = 'splash';
  static const String register = 'register';
}

Future<void> showLoadingPopup(BuildContext context, String message) async {
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text('   $message')
                  ],
                )),
          ));
}

Future<void> showErrorPopup(BuildContext context, String message) async {
  await showDialog(
      context: context,
      builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 50,
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                      child: Text(
                    '   $message',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ))),
            ),
          ));
}
