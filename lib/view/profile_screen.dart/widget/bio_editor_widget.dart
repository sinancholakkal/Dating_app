import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BioEditorWidget extends StatelessWidget {
  final TextEditingController bioController;
  final ValueChanged<String>? onChanged;

  const BioEditorWidget({
    super.key,
    required this.bioController,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: bioController,
          maxLines: 4,
          maxLength: 200,
          onChanged: onChanged,
          style: GoogleFonts.poppins(
            color: kWhite,
            height: 1.5,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Write something fun about yourself...",
            hintStyle: GoogleFonts.poppins(
              color: kWhite54,
              fontSize: 16,
            ),
            filled: true,
            fillColor: kWhite.withOpacity(0.08),
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: kWhite.withOpacity(0.15),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: kWhite.withOpacity(0.15),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: primary,
                width: 2,
              ),
            ),
            counterText: "",
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Share your hobbies, interests, and what makes you unique",
                style: GoogleFonts.poppins(
                  color: kWhite54,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: kWhite.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                "${bioController.text.length}/200",
                style: GoogleFonts.poppins(
                  color: bioController.text.length > 180
                      ? Colors.orange
                      : bioController.text.length > 190
                          ? Colors.red
                          : kWhite70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
