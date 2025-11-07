import 'dart:ui';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
class SettingsCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final IconData icon;
  const SettingsCardWidget({super.key, required this.title, required this.description, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.only(bottom: 24.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: kWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: GoogleFonts.poppins(color: kWhite70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
// Widget buildPrivacyPolicyLink(BuildContext context) {
//   final Uri privacyPolicyUrl = Uri.parse('https://www.termsfeed.com/live/364ad209-b439-4b36-8241-f750b34a410d');

//   return Padding(
//     padding: const EdgeInsets.only(bottom: 24.0),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () async {
//             if (await canLaunchUrl(privacyPolicyUrl)) {
//               await launchUrl(privacyPolicyUrl, mode: LaunchMode.inAppWebView);
//             } else {
//               flutterToast(msg: 'Could not open privacy policy');
//             }
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.06),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white.withOpacity(0.10)),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: primary.withOpacity(0.18),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.privacy_tip_outlined, color: Colors.white),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Privacy & Policy',
//                         style: GoogleFonts.poppins(
//                           color: kWhite,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'Read how we protect your data and privacy',
//                         style: GoogleFonts.poppins(color: kWhite70, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: Text(
//                     'Open',
//                     style: GoogleFonts.poppins(
//                       color: textDark,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }