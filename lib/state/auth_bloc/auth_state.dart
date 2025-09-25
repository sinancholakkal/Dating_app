part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}
class InvalidNumberState extends AuthState{
  final String msg;

  InvalidNumberState({required this.msg});
  
}
class AuthCodeSentSuccessState extends AuthState {
  final String phoneNumber;
  AuthCodeSentSuccessState({required this.phoneNumber});
}

class AuthVerifiedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({required this.message});
}