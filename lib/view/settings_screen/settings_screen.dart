import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/settings_screen/widget.dart/settings_card.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});


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
            "Settings",
            style: GoogleFonts.poppins(
              color: kWhite,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontSize: 24,
            ),
          ),
        ),
        // body: ListView.builder(
        //   itemCount: settingsList.length,
        //   itemBuilder: (context, index) {
        //     return SettingsCardWidget(
        //       icon: settingsList[index]['icon'],
        //       title: settingsList[index]['title'],
        //       description: settingsList[index]['description'],
        //       onTap: settingsList[index]['onTap'],
        //     );
        //   },
        // ),
        body: Column(
          children: [
            SettingsCardWidget(
              title: "Privacy Policy",
              description: "Read how we protect your data and privacy",
              onTap: () async {
                final Uri privacyPolicyUrl = Uri.parse(
                  'https://www.termsfeed.com/live/364ad209-b439-4b36-8241-f750b34a410d',
                );
                if (await canLaunchUrl(privacyPolicyUrl)) {
                  await launchUrl(
                    privacyPolicyUrl,
                    mode: LaunchMode.inAppWebView,
                  );
                } else {
                  flutterToast(msg: 'Could not open privacy policy');
                }
              },
              icon: Icons.privacy_tip_outlined,
            ),
            SettingsCardWidget(title: "Sensitive Content", description: "Enable or disable sensitive content", onTap: ()=>context.push("/sensitive"), icon: Icons.security_outlined)
          ],
        ),
      ),
    );
  }
}
