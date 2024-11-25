part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

final class LoginInitial extends LoginState {
  // LoginInitial({this.error = false});
  // bool error;
  @override
  List<Object?> get props => [];
}

class LoginError extends LoginState{
  final String error;

  LoginError({required this.error});
  @override
  List<Object?> get props => [error];
}