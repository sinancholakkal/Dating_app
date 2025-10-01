import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showUpgradeSheet(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Make the default background transparent
    builder: (context) {
      // Use a fixed height for the sheet
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: const UpgradeBottomSheet(),
      );
    },
  );
}

class UpgradeBottomSheet extends StatelessWidget {
  const UpgradeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Use the appGradient and rounded top corners
      decoration: const BoxDecoration(
        gradient: appGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Draggable handle indicator
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const Spacer(),
            
            // Premium Icon
            //Icon(CupertinoIcons.crown_fill, color: kWhite, size: 60),
            const SizedBox(height: 16),
            
            // Header Text
            Text(
              "Go Unlimited!",
              style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: kWhite),
            ),
            const SizedBox(height: 8),
            Text(
              "You're out of swipes for today. Upgrade to unlock more features.",
              style: GoogleFonts.poppins(fontSize: 16, color: kWhite70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // 2. Clear list of upgrade features
            _buildFeatureRow(icon: CupertinoIcons.heart_fill, text: "Unlimited Likes"),
            _buildFeatureRow(icon: Icons.replay, text: "Rewind Your Last Swipe"),
            _buildFeatureRow(icon: CupertinoIcons.eye_fill, text: "See Who Likes You"),
            _buildFeatureRow(icon: Icons.star_sharp, text: "5 Free Super Likes a Week"),
            
            const Spacer(),
            
            // 3. Strong Call to Action Button
            ElevatedButton(
              onPressed: () {
                flutterToast(msg: "Upgrade feature is coming soon!");
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: kWhite,
                foregroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                "Upgrade Now",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Not Now",
                style: GoogleFonts.poppins(color: kWhite70, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each feature row
  Widget _buildFeatureRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: kWhite, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 16, color: kWhite, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}