import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/blocs/login_page/bloc/login_bloc.dart';
import 'package:quiz/firebase_options.dart';
import 'package:quiz/ui/homescreen.dart';
import 'package:quiz/ui/login_page.dart';
import 'package:quiz/ui/quiz_page.dart';
import 'package:quiz/ui/register.dart';
import 'package:quiz/ui/splashscreen.dart';
import 'package:quiz/utils/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: NavigatorConst.splash,
        routes: routes,
        title: "QuiGo",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const Quizpage(),
      ),
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  NavigatorConst.home: (context) => const Homescreen(),
  NavigatorConst.login: (context) => const LoginScreen(),
  NavigatorConst.quiz: (context) => const Quizpage(),
  NavigatorConst.splash: (context) => const Splashscreen(),
  NavigatorConst.register: (context) => const RegisterScreen(),
};






/*
ValueListenableBuilder(
              valueListenable: selected,
              builder: (context, value, child) => ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('${widget.q} ' * 10),
                        )
                      : index == 5
                          ? TextButton(
                              onPressed: () {
                                answered++;

                                _controller.forward();
                                _controller.addStatusListener((status) {
                                  if (status.name == 'completed') {
                                    myList.notifyListeners();
                                    _controller.reset();
                                  }
                                });
                              },
                              child: const Text("Submit"))
                          : CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: selected.value == index,
                              onChanged: (value) {
                                if (value!) {
                                  selected.value = index;
                                } else {
                                  selected.value = null;
                                }
                              },
                              title: Text(index.toString()),
                            );
                },
              ),
            ),
*/