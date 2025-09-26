import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authServices = AuthService();
  AuthBloc() : super(AuthInitial()) {
    // Handler for sending OTP
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoadingState());
      await Future.delayed(Duration(seconds: 2));
      log(event.phoneNumber.length.toString());
      if (event.phoneNumber.length == 10) {
        emit(AuthCodeSentSuccessState(phoneNumber: event.phoneNumber));
      } else if (event.phoneNumber.isEmpty) {
        emit(InvalidNumberState(msg: AppStrings.enterNo));
      } else {
        emit(InvalidNumberState(msg: AppStrings.enterValidNo));
      }
    });

    // Handler for verifying OTP
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoadingState());
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (event.otp == "123456") {
        // Mock success
        emit(AuthVerifiedState());
      } else {
        // Mock failure
        emit(AuthErrorState(message: "Invalid OTP. Please try again."));
      }
    });

    // Handler for resetting the flow
    on<ResetAuthEvent>((event, emit) {
      emit(AuthInitial());
    });

    on<GoogleSigninEvent>((event, emit) async {
      try {
        log("signing cservice called");
        final user = await authServices.signInWithGoogle();

        if (user != null) {
          final docRef = FirebaseFirestore.instance
              .collection("user")
              .doc(user.uid);
          final docSnap = await docRef.get();

          if (docSnap.exists) {
            log("User has account");
            final data = docSnap.data() as Map<String, dynamic>;

            if (data['isSetupProfile'] == true) {

              emit(AuthSuccessNavigateToHome());
            } else {
              
              emit(AuthSuccessNavigateToProfileSetup());
            }
          } else {
            log("User has not account");
            await docRef.set({
              "email": user.email,
              "name": user.displayName,
              "createdAt": FieldValue.serverTimestamp(),
              "isSetupProfile": false,
            });
            emit(AuthSuccessNavigateToProfileSetup());
          }
        } else {
          emit(AuthErrorState(message: "Login Failed"));
        }
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }
}
