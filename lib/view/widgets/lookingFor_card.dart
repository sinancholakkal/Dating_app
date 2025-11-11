
  import 'dart:developer';
import 'dart:ui';

import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LookingForCard extends StatelessWidget {
  final LookingForModel item;
  final VoidCallback onTap;
   bool? isSelected;
   LookingForCard({super.key, 
    required this.item,
    required this.onTap, this.isSelected,
  });


  @override
  Widget build(BuildContext context) {
    log("===${isSelected}===");
    isSelected??=item.isSelected;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected! ? primary : Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kWhite.withOpacity(0.08)),
              boxShadow: isSelected!
                  ? [
                      BoxShadow(
                        color: primary.withOpacity(0.35),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, color: isSelected! ?kWhite: primary , size: 32),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    color: kWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: GoogleFonts.poppins(
                    color: kWhite70,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected!)
            Positioned(
              bottom: -12,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: kWhite,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.check, size: 18, color: primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
