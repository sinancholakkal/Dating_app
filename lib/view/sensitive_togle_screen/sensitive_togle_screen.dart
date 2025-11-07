import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_sizedbox.dart';
import 'package:dating_app/view/widgets/text_feild.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SensitiveTogleScreen extends StatelessWidget {
  const SensitiveTogleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: kWhite),
          title: Text(
            "Sensitive Content",
            style: GoogleFonts.poppins(
              color: kWhite,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontSize: 24,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(text: "I want to see", fontWeight: FontWeight.w700, size: 18, color: kWhite.withValues(alpha: 0.8),),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: TextWidget(text: "By switching it on, you will see more explicit photo content: such as swimwear, cleavage or revealing clothing. Such content will appear blurred by default when off.",maxLine: 4,textAlign: TextAlign.start,),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              AppSizedBox.h16,
              
const SensitivePolicyContainer(),
            ],
          ),
        ),
      ),
    );
  }
}


