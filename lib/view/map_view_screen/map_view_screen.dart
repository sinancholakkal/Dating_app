import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/utils/app_color.dart'; // Using kWhite and primary
import 'package:dating_app/view/map_view_screen/widgets/show_user_profile_mapview.dart';
import 'package:dating_app/view/map_view_screen/widgets/user_marker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapViewScreen extends StatefulWidget {
  final Position currentPosition;
  final List<UserProfile> otherUsersData;
  final double searchRadiusMeters;

  const MapViewScreen({
    super.key,
    required this.currentPosition,
    required this.otherUsersData,
    this.searchRadiusMeters = 1000,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapController _mapController = MapController();
  late final LatLng _currentUserLatLng;

  @override
  void initState() {
    super.initState();
    _currentUserLatLng = LatLng(
      widget.currentPosition.latitude,
      widget.currentPosition.longitude,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. The Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentUserLatLng,
              initialZoom: 15,
            ),
            children: [
              // Map Tiles
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.earning.lovematch',
              ),

              // Search Radius Circle
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _currentUserLatLng,
                    color: Colors.blue.withOpacity(0.1),
                    borderColor: kWhite,
                    borderStrokeWidth: 2,
                    radius: widget.searchRadiusMeters,
                    useRadiusInMeter: true,
                  ),
                ],
              ),

              // Other User Markers
              MarkerLayer(
                markers: widget.otherUsersData
                    .map(
                      (user) => userMarkerWidget(user, () {
                        showUserProfileSheetMapView(
                          context,
                          user,
                          user.getImages![0],
                        );
                      }),
                    )
                    .whereType<Marker>()
                    .toList(),
              ),

              // Current User Marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentUserLatLng,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[400],
                        border: Border.all(color: kWhite, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(Icons.location_on, color: kWhite, size: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Floating Back Button
          Positioned(
            top: 50,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(Icons.arrow_back, color: primary, size: 24),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _mapController.move(_currentUserLatLng, 15);
              },
              backgroundColor: kWhite,
              child: Icon(Icons.my_location, color: primary),
            ),
          ),
        ],
      ),
    );
  }
}
