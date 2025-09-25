part of 'profile_setup_bloc.dart';

abstract class ProfileSetupEvent {}

class ContinueTappedEvent extends ProfileSetupEvent {
  final int currentPage;
  final PageController pageController;
  ContinueTappedEvent( {required this.pageController,required this.currentPage});
}

class GoBackTappedEvent extends ProfileSetupEvent {
  final PageController pageController;
    final int currentPage;
  GoBackTappedEvent( {required this.currentPage,required this.pageController});
}
class StartProfileSetupEvent extends ProfileSetupEvent{}
class StartProfileSetup extends ProfileSetupEvent {}