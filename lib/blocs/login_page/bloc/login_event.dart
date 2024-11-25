part of 'login_bloc.dart';

class LoginEvent {
  final BuildContext context;
  final String userId;
  final String password;

  LoginEvent(
      {required this.userId, required this.password, required this.context});
}
