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

class AuthSuccessNavigateToHome extends AuthState{}
class AuthSuccessNavigateToProfileSetup extends AuthState{}
class AuthNoFountState extends AuthState{}
class LogoutSuccessState extends AuthState{}
// Tells the UI to switch to the OTP input view
class AuthCodeSentSuccess extends AuthState {
  final String verificationId;
  final String phoneNumber;
  AuthCodeSentSuccess({required this.verificationId,required this.phoneNumber});
}

// Final success state after verification
class AuthVerified extends AuthState {}


class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
class OtpVerifiedState extends AuthState{}


class GoogleAuthError extends AuthState {
  final String message;
  GoogleAuthError({required this.message});
}
class AuthSuccessNavigateToProfileSetupLookingfor extends AuthState{}