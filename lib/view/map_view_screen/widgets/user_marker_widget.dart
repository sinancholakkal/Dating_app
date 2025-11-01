import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Marker? userMarkerWidget(UserProfile user, VoidCallback onTap) {
    final GeoPoint? geoPoint = user.currentGeoPoint;
    if (geoPoint == null) {
      log('User ${user.id} has no location data.');
      return null;
    }

    final String? imageUrl =
        (user.getImages != null && user.getImages!.isNotEmpty)
        ? user.getImages![0]
        : null;

    return Marker(
      point: LatLng(geoPoint.latitude, geoPoint.longitude),
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap:onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kWhite,
            border: Border.all(color: primary, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null
                ? Icon(Icons.person, color: Colors.grey[400], size: 24)
                : null,
          ),
        ),
      ),
    );
  }