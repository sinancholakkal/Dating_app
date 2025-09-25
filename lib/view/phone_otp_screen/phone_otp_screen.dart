import 'package:dating_app/state/auth_bloc/auth_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/widgets/otp_input_view.dart';
import 'package:dating_app/view/widgets/phone_input_view.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({super.key});

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  late final TextEditingController _phoneController;


  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("Phone Verification"),backgroundColor: primary,),
      body: Container(
        decoration: BoxDecoration(
          gradient: appGradient
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
              
              flutterToast(msg: state.message,backgroundColor: Kred);
            }
            if(state is InvalidNumberState){
              flutterToast(msg:state.msg);
            }
            if (state is AuthVerifiedState) {
              flutterToast(msg: AppStrings.phVerified);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthCodeSentSuccessState) {
                return OtpInputView(phoneNumber: state.phoneNumber);
              }
              return PhoneInputView();
            },
          ),
        ),
      ),
    );
  }

}