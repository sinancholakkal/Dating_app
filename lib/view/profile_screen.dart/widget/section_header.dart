import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showDivider;

  const SectionHeader({
    super.key,
    required this.title,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: kWhite,
          ),
        ),
        if (showDivider) ...[
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 1,
            width: double.infinity,
            color: kWhite.withOpacity(0.08),
          ),
        ],
      ],
    );
  }
}

