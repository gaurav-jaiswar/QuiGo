import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:quiz/ui/homescreen.dart';
import 'package:quiz/utils/const.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>(_login);
  }

  final _auth = FirebaseAuth.instance;
  FutureOr<void> _login(LoginEvent event, Emitter<LoginState> emit) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: event.userId, password: event.password);
      print('object');
      Navigator.of(event.context).pushReplacementNamed(NavigatorConst.home);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            emit(LoginError(error: "Invalid Email"));
            break;
          case 'invalid-credential':
            emit(LoginError(
                error: "User Not Found\nPlease register to continue..."));
            break;
          case 'wrong-password':
            emit(LoginError(error: "Wrong Password"));
            break;
          default:
            emit(LoginError(error: "Something Went Wrong"));
        }
      }
    }
  }
}
