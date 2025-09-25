part of 'profile_setup_bloc.dart';

@immutable
sealed class ProfileSetupState {}

// Initial state when the screen is first loaded.
final class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetUpNextPage extends ProfileSetupState{
  final int currentPage;

  ProfileSetUpNextPage({required this.currentPage});
  
}

// Optional: A state for when the entire profile is submitted successfully
final class ProfileSetupSuccess extends ProfileSetupState {}

// Optional: A state to represent an error during submission
final class ProfileSetupFailure extends ProfileSetupState {
  final String error;
  ProfileSetupFailure({required this.error});
}