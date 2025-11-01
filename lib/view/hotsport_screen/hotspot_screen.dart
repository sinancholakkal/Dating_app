import 'dart:developer';

import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/location_service.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/favorite_screen/widgets/item_show_screen.dart';
import 'package:dating_app/view/map_view_screen/map_view_screen.dart';
import 'package:dating_app/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
// For DocumentSnapshot if needed elsewhere
import 'dart:async';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class HotspotScreen extends StatefulWidget {
  const HotspotScreen({super.key});

  @override
  State<HotspotScreen> createState() => _HotspotScreenState();
}

class _HotspotScreenState extends State<HotspotScreen>
    with WidgetsBindingObserver {
  User? currentUser;
  Position? currentPosition;
  StreamSubscription? _nearbyUsersSubscription;
  StreamSubscription? _positionSubscription;
  List<UserProfile> nearbyUserProfiles = []; // Changed to List<UserProfile>
  bool _isLoadingLocation = true;
  String _locationError = '';
  final double searchRadiusMeters = 1000.0;
  UserProfile? accUserProfile;

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeUserAndLocation();
  }

  @override
  void dispose() {
    _nearbyUsersSubscription?.cancel();
    _positionSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    if (currentUser?.uid != null) {
      setOffline(currentUser!.uid);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (currentUser?.uid == null) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      log('App is paused or detached. Setting user offline.');
      setOffline(currentUser!.uid);
      _nearbyUsersSubscription?.cancel();
      _positionSubscription?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      log('App is resumed. Re-initializing location and nearby users.');
      _initializeUserAndLocation();
    }
  }

  Future<void> _initializeUserAndLocation() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'User not logged in.';
      });
      return;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          if (!mounted) return;
          setState(() {
            _isLoadingLocation = false;
            _locationError = 'Location permissions denied.';
          });
          return;
        }
      }

      Position initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() {
        currentPosition = initialPosition;
        _isLoadingLocation = false;
      });

      await updateUserLocation(currentUser!.uid, initialPosition);
      _startListeningForNearbyUsers();
      _startLocationUpdates();
    } catch (e) {
      log('Error initializing location: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'Failed to get location: ${e.toString()}';
      });
    }
  }

  void _startListeningForNearbyUsers() {
    if (currentUser == null || currentPosition == null) return;

    _nearbyUsersSubscription?.cancel();

    // CALL THE NEW FUNCTION THAT RETURNS USER PROFILES
    _nearbyUsersSubscription =
        getNearbyUsersWithProfiles(
          // Changed function name
          currentUser!.uid,
          currentPosition!,
          searchRadiusMeters,
        ).listen(
          (profiles) {
            // Listens to UserProfile list
            if (!mounted) return;
            setState(() {
              nearbyUserProfiles = profiles; 
            });
            log('Found ${profiles.length} nearby user profiles.');
          },
          onError: (error) {
            log('Error listening for nearby users: $error');
            if (!mounted) return;
            setState(() {
              _locationError =
                  'Error fetching nearby users: ${error.toString()}';
            });
          },
        );
  }

  void _startLocationUpdates() {
    _positionSubscription?.cancel();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) async {
            if (currentUser != null && position != currentPosition) {
              if (!mounted) return;
              setState(() {
                currentPosition = position;
              });
              log(
                'Location updated: ${position.latitude}, ${position.longitude}',
              );
              await updateUserLocation(currentUser!.uid, position);
              _startListeningForNearbyUsers();
            }
          },
          onError: (error) {
            log('Error in location stream: $error');
            if (!mounted) return;
            setState(() {
              _locationError = 'Error updating location: ${error.toString()}';
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is GetSuccessState) {
          accUserProfile = state.userProfile;
        }
      },
      child: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Nearby',
              style: GoogleFonts.poppins(
                color: kWhite,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              CustomButton(
                width: 100,
                text: "Nearby",
                fontWeight: FontWeight.w700,
                icon: Icon(Icons.location_on, color: kWhite,size: 17,),
                onTap: () {
                  pushNewScreen(
                    context,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    withNavBar: false,
                    screen: MapViewScreen(currentPosition: currentPosition!, otherUsersData: nearbyUserProfiles),
                  );
                },
              ),
            ],
          ),
          body: _isLoadingLocation
              ? Center(
                  child: CircularProgressIndicator(
                    color: kWhite,
                    strokeWidth: 3,
                  ),
                )
              : _locationError.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Icon(
                            Icons.location_off,
                            color: Colors.red.shade300,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Location Error",
                          style: GoogleFonts.poppins(
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _locationError,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: kWhite70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : nearbyUserProfiles.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Icon(
                            Icons.location_searching,
                            color: Colors.white.withOpacity(0.6),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No one nearby yet",
                          style: GoogleFonts.poppins(
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Keep exploring to find people within 50 meters",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: kWhite70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: nearbyUserProfiles.length,
                  itemBuilder: (context, index) {
                    final UserProfile userProfile = nearbyUserProfiles[index];
                    final String userName = userProfile.name;
                    final List<String>? userProfileImageUrls =
                        userProfile.getImages;
                    final double? distance = userProfile.distanceInMeters;

                    String distanceText = 'Unknown distance';
                    if (distance != null) {
                      distanceText =
                          '${distance.toStringAsFixed(0)}m away';
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.04),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            pushNewScreen(
                              context,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                              withNavBar: false,
                              screen: ItemShowScreen(
                                userProfile: userProfile,
                                index: 0,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: primary.withOpacity(0.15),
                                    backgroundImage: userProfileImageUrls != null && userProfileImageUrls.isNotEmpty
                                        ? NetworkImage(userProfileImageUrls[0])
                                        : null,
                                    child: userProfileImageUrls == null || userProfileImageUrls.isEmpty
                                        ? Icon(Icons.person, color: kWhite, size: 24)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
                                        style: GoogleFonts.poppins(
                                          color: kWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: primary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            distanceText,
                                            style: GoogleFonts.poppins(
                                              color: kWhite70,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Like button
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.green.withOpacity(0.2),
                                        Colors.green.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: () {
                                        if (accUserProfile == null) return;
                                        context.read<UserActionsBloc>().add(
                                          UserLikeActionEvent(
                                            likeUserId: userProfile.id,
                                            likeUserName: userProfile.name,
                                            currentUserId: accUserProfile!.id,
                                            currentUserName: accUserProfile!.name,
                                            image: accUserProfile!.getImages![0],
                                          ),
                                        );
                                        setState(() {
                                          nearbyUserProfiles.removeAt(index);
                                        });
                                      },
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.green.shade300,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
