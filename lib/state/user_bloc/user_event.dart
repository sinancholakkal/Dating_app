part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class AddUserProfileSetupEvent extends UserEvent{
  final UserProfile userProfile;
  final List<LookingForModel> lookingFor;
  AddUserProfileSetupEvent({required this.userProfile, required this.lookingFor});
  
} 

class GetUserProfileEvent extends UserEvent{}

class UpdateUserPrfileEvent extends UserEvent{
  final UserCurrentModel userCurrentModel;
  final List<String>deleteImages;

  UpdateUserPrfileEvent({required this.userCurrentModel, required this.deleteImages});
  
}