// Assuming these are your color definitions from 'app_color.dart'
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class SensitivePolicyContainer extends StatelessWidget {
  const SensitivePolicyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4), // Dark translucent background for contrast against the appGradient
        borderRadius: BorderRadius.circular(16),
        // Subtle outer border to define the shape clearly
        border: Border.all(color: kWhite.withOpacity(0.1), width: 1.5), 
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Title and Icon
          Row(
            children: [
              Text(
                'WE DO NOT ALLOW:',
                style: GoogleFonts.poppins(
                  color: kWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.info_outline,
                color: kWhite.withOpacity(0.7),
                size: 20,
              ),
            ],
          ),
          
          const Divider(height: 30, color: kGrey), // Separator

          // Section 1: Photos Policy
          Text(
            'In profile photos and chats',
            style: GoogleFonts.poppins(
              color: kWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We strictly prohibit content that violates our policies, including: full or partial nudity, graphic violence, illegal content, or hate symbols. We may blur or remove images deemed excessively revealing or inappropriate.',
            style: GoogleFonts.poppins(
              color: kWhite70, // Use a softer white for body text
              fontSize: 14,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 24), // Vertical spacing

          // Section 2: Text/Chat Policy
          Text(
            'In user biographies and messages',
            style: GoogleFonts.poppins(
              color: kWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Messages that contain harassment, hate speech, threats, phishing attempts, spam, advertising, or sharing of personal contact information (PII) too early will be flagged and removed.',
            style: GoogleFonts.poppins(
              color: kWhite70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}