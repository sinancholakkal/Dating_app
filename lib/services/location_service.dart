// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'dart:developer';

// class LocationService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFunctions _functions = FirebaseFunctions.instance;

//   // Request location permissions
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       log("Location services are disabled.");
//       // Consider showing a dialog to the user here.
//       return false;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         log("Location permissions were denied.");
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       log("Location permissions are permanently denied.");
//       // Consider showing a dialog explaining how to enable in settings.
//       return false;
//     }
//     return true;
//   }

//   // Get current position and call Cloud Function to update hotspot status
//   Future<void> updateCurrentUserLocationAndHotspotStatus() async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       log("User not logged in.");
//       return;
//     }

//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) {
//       log("Location permissions not granted.");
//       return;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 10), // Add a timeout
//       );

//       // Call Cloud Function to update location and determine hotspot status
//       // The Cloud Function will handle writing to 'users' collection
//       final HttpsCallable callable = _functions.httpsCallable('updateUserHotspotStatus');
//       final result = await callable.call({
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//       });

//       if (result.data['success']) {
//         log("Location and Hotspot status updated successfully: ${result.data['message']}");
//       } else {
//         log("Failed to update hotspot status: ${result.data['message']}");
//       }

//     } on FirebaseFunctionsException catch (e) {
//       log("Firebase Functions Error updating hotspot status: ${e.code} - ${e.message}");
//       // Handle specific function errors
//     } catch (e) {
//       log("Error updating location or hotspot status: $e");
//     }
//   }

//   // Dummy function for checking if two users are matched
//   // THIS NEEDS TO BE REPLACED WITH YOUR ACTUAL MATCH LOGIC
//   Future<bool> areUsersMatched(String userId1, String userId2) async {
//     // In a real app, you would query your 'matches' collection
//     // Example:
//     // final querySnapshot = await _firestore.collection('matches')
//     //     .where('participants', arrayContainsAny: [userId1, userId2]) // Or similar
//     //     .get();
//     // return querySnapshot.docs.any((doc) {
//     //   final participants = List<String>.from(doc['participants']);
//     //   return participants.contains(userId1) && participants.contains(userId2);
//     // });
//     await Future.delayed(const Duration(milliseconds: 100)); // Simulate network delay
//     return false; // For now, assume no one is matched to demonstrate blurring
//   }
// }
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/user_profile_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

// Initialize FirebaseFirestore
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// --- Function to update or set a user's location ---
Future<void> updateUserLocation(String userId, Position position) async {
  // Create a GeoFirePoint by instantiating it with GeoPoint
  final GeoFirePoint geoFirePoint = GeoFirePoint(
    GeoPoint(position.latitude, position.longitude),
  );

  // The documentation shows saving the GeoFirePoint's 'data' map
  // into a sub-field like 'geo' within your document.
  // This 'geo' field will contain {'geopoint': GeoPoint(...), 'geohash': '...'}.
  await firestore.collection('user_locations').doc(userId).set({
    'userId': userId,
    'geo': geoFirePoint
        .data, // This is key: storing the geopoint and geohash within a 'geo' map
    'lastUpdate': FieldValue.serverTimestamp(),
    'isOnline': true,
  }, SetOptions(merge: true));
}

Future<bool> isUserMatched({
  required String currentUserId,
  required String otherUserId,
}) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserId)
        .get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data.containsKey('matches')) {
        final List<dynamic> matches = data['matches'] as List<dynamic>;
        return matches.contains(otherUserId);
      }
    }
    return false; // No matches field or document doesn't exist
  } catch (e) {
    print('Error checking if user is matched: $e');
    return false; // Assume not matched on error
  }
}

Future<bool> isUserLiked({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('like').doc(currentUserId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('likes')) {
          final List<dynamic> likes = data['likes'] as List<dynamic>;
          // Check if any map in the list contains 'likedId' equal to otherUserId
          return likes.any((likeMap) =>
              likeMap is Map<String, dynamic> && likeMap['likedId'] == otherUserId);
        }
      }
      return false;
    } catch (e) {
      print('Error checking if user is liked: $e');
      return false;
    }
  }

Stream<List<UserProfile>> getNearbyUsersWithProfiles(
  String currentUserId,
  Position centerPosition,
  double radiusInMeters,
) {
  final GeoPoint centerGeoPoint =
      GeoPoint(centerPosition.latitude, centerPosition.longitude);
  final GeoFirePoint center = GeoFirePoint(centerGeoPoint);

  final double radiusInKm = radiusInMeters / 100;
  const String geoDataField = 'geo';

  final collectionReference = firestore.collection('user_locations');

  // This helper function is correct, no changes needed.
  GeoPoint geopointFrom(Map<String, dynamic> data) {
    final geoMap = data[geoDataField] as Map<String, dynamic>;
    return geoMap['geopoint'] as GeoPoint;
  }

  // This query builder is correct, no changes needed.
  Query<Map<String, dynamic>> customQueryBuilder(
    Query<Map<String, dynamic>> query,
  ) =>
      query
          .where('isOnline', isEqualTo: true)
          .where('userId', isNotEqualTo: currentUserId);

  final stream = GeoCollectionReference<Map<String, dynamic>>(
    collectionReference,
  ).subscribeWithin(
    center: center,
    radiusInKm: radiusInKm,
    field: geoDataField,
    geopointFrom: geopointFrom,
    queryBuilder: customQueryBuilder,
  );
  log("started");
  // --- REFACTORED AND OPTIMIZED PART ---
  return stream.asyncMap((List<DocumentSnapshot<Map<String, dynamic>>> documents) async {
    if (documents.isEmpty) {
      return []; // Return early if no locations are found
    }

    // Create a list of futures to run all checks in parallel, not one by one.
    final futures = documents.map((doc) async {
      final data = doc.data();
      if (data == null) return null;
     final otherUserId = data['userId']; 
      if (otherUserId == null || otherUserId is! String) {
    // If it's invalid, log it and safely skip this document.
    log('Skipping location document with invalid/missing userId: ${doc.id}');
    return null; 
  }
      final geoMap = data[geoDataField] as Map<String, dynamic>;
      final docGeoPoint = geoMap['geopoint'] as GeoPoint;

      // Final precise distance check
      final double distance = Geolocator.distanceBetween(
        centerPosition.latitude,
        centerPosition.longitude,
        docGeoPoint.latitude,
        docGeoPoint.longitude,
      );

      if (distance > radiusInMeters) {
        return null; // Skip user if they are outside the precise radius
      }

      // Check match and like status concurrently
      final results = await Future.wait([
        isUserMatched(currentUserId: currentUserId, otherUserId: otherUserId),
        isUserLiked(currentUserId: currentUserId, otherUserId: otherUserId),
      ]);
      final bool isMatch = results[0];
      final bool isUserLike = results[1];
      
      // The main filtering logic: only proceed if not matched AND not liked
      //if (!isMatch && !isUserLike) {
        try {
          log("Fetching profile for $otherUserId");
          final UserProfile? profile = await UserProfileServices().fetchUserProfile(userId: otherUserId);
          if (profile == null) return null;

          // Return the complete UserProfile with location data
          return UserProfile(
            id: profile.id,
            name: profile.name,
            bio: profile.bio,
            getImages: profile.getImages,
            currentGeoPoint: docGeoPoint,
            distanceInMeters: distance,
            age: profile.age,
            gender: profile.gender,
            interests: profile.interests,
          );
        } catch (e) {
          log('Error fetching profile for $otherUserId: $e');
          return null; // Return null if there's an error fetching the profile
        }
     // } else {
        // User was filtered out (already matched or liked)
    //    return null;
    //  }
    }).toList();

    // Wait for all the parallel checks to complete
    final List<UserProfile?> potentialProfiles = await Future.wait(futures);

    // Filter out any null values (users who were too far, already matched, or had errors)
    // and return the final, clean list.
    return potentialProfiles.whereType<UserProfile>().toList();
  });
}

// --- Function to set user's status to offline ---
Future<void> setOffline(String userId) async {
  await firestore.collection('user_locations').doc(userId).update({
    'isOnline': false,
    'lastUpdate': FieldValue.serverTimestamp(),
  });
}
