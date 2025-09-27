part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class ProfileLoadingState extends UserState{}

class ProfileSuccessState extends UserState{}

class ErrorState extends UserState{
  final String msg;

  ErrorState({required this.msg});
}