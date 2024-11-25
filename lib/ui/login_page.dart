import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/blocs/login_page/bloc/login_bloc.dart';
import 'package:quiz/utils/const.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userId = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child:
                    Hero(tag: 'hero', child: Image.asset("assets/mylogo.png",
                    height: 200,)),
              ),
              const SizedBox(height: 20),
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
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginError) {
                    return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(state.error,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red)));
                  } else {
                    return const SizedBox(height: 15);
                  }
                },
              ),
              MaterialButton(
                padding: const EdgeInsets.all(10),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  context.read<LoginBloc>().add(LoginEvent(
                      userId: userId.text,
                      password: password.text,
                      context: context));
                  userId.clear();
                  password.clear();
                },
                color: Colors.blueAccent,
                minWidth: double.maxFinite,
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(NavigatorConst.register);
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueAccent,
                      fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
