import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/favorite_screen/widgets/item_show_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

void showUserProfileSheetMapView(
    BuildContext context,
    UserProfile user,
    String? imageUrl,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: imageUrl != null
                    ? CachedNetworkImageProvider(imageUrl)
                    : null,
                child: imageUrl == null
                    ? Icon(Icons.person, color: Colors.grey[400], size: 40)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                '${user.name}, ${user.age}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.bio.isEmpty ? "No bio available." : user.bio,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  pushNewScreen(
                    context,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    withNavBar: false,
                    screen: ItemShowScreen(userProfile: user, index: 0),
                  );
                  log("Tapped View Profile for ${user.name}");
                },
                child: Text(
                  'View Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }