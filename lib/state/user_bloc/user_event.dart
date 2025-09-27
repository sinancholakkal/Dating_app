part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class AddUserProfileSetupEvent extends UserEvent{
  final UserProfile userProfile;

  AddUserProfileSetupEvent({required this.userProfile});
  
} 