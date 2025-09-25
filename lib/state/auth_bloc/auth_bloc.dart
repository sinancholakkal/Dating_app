import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    // Handler for sending OTP
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoadingState());
      await Future.delayed(Duration(seconds: 2));
      log(event.phoneNumber.length.toString());
      if(event.phoneNumber.length==10){
        emit(AuthCodeSentSuccessState(phoneNumber: event.phoneNumber));
      }else if(event.phoneNumber.isEmpty){
        emit(InvalidNumberState(msg: AppStrings.enterNo));
      }else{
        emit(InvalidNumberState(msg: AppStrings.enterValidNo));
      }
      
    });

    // Handler for verifying OTP
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoadingState());
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (event.otp == "123456") { // Mock success
        emit(AuthVerifiedState());
      } else { // Mock failure
        emit(AuthErrorState(message: "Invalid OTP. Please try again."));
      }
    });

    // Handler for resetting the flow
    on<ResetAuthEvent>((event, emit) {
      emit(AuthInitial());
    });
  }
}