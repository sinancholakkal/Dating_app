import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  // 1. Set the initial state to ProfileSetupInitial()
  int currentPage = 0;
  ProfileSetupBloc() : super(ProfileSetupInitial()) {
    on<StartProfileSetup>((event, emit) {
     // emit( ProfileSetupInProgress());
    });

    on<ContinueTappedEvent>((event, emit) {
      if(event.currentPage<1){
        currentPage = event.currentPage+1;
        event.pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        
      );
      emit(ProfileSetUpNextPage(currentPage: currentPage));
      }
      
    });

    on<GoBackTappedEvent>((event, emit) {
      if (currentPage > 0) {
        currentPage = event.currentPage-1;
        event.pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      emit(ProfileSetUpNextPage(currentPage: currentPage));
      }
    });

    // // 4. Add an event to START the process, which moves from Initial to InProgress
    // on<StartProfileSetupEvent>((event, emit) {
    //   emit( ProfileSetupInProgress());
    // });
  }
}