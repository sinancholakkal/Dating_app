import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapViewScreen extends StatelessWidget {
  final Position currentPosition;
  MapViewScreen({super.key, required this.currentPosition});

  MapController mapController = MapController();
  

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> otherUsersData = [
    {
      'id': 'user1',
      'lat': currentPosition.latitude + 0.005, // Offset for example
      'lng': currentPosition.longitude - 0.005,
    },
    {
      'id': 'user2',
      'lat': currentPosition.latitude - 0.003,
      'lng': currentPosition.longitude + 0.004,
    },
    {
      'id': 'user3',
      'lat': currentPosition.latitude + 0.002,
      'lng': currentPosition.longitude + 0.001,
    },
  ];
    return Scaffold(
      body: SafeArea(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: LatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ), // Center the map over London
            initialZoom: 13,
          ),
          children: [
             TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.earning.lovematch',
              errorTileCallback: (tile, error, stackTrace) {},
              tileProvider: NetworkTileProvider(),
              fallbackUrl: null,
            ),
            MarkerLayer(
            markers: [
              ...otherUsersData.map((user) => Marker(
                point: LatLng(user['lat'], user['lng']),
                width: 80,
                height: 80,
                child: Icon(
                  Icons.person_pin_circle_rounded,
                  color: Colors.blue,
                  size: 50,
                ),
              )),
              Marker(
                point: LatLng(currentPosition.latitude, currentPosition.longitude),
                width: 80,
                height: 80,
                // This is the widget for your marker
                child: Icon(
                  Icons.person_pin_circle_rounded,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
            ],
          ),
            CircleLayer(circles: [
            CircleMarker(
              point: LatLng(currentPosition.latitude, currentPosition.longitude),
              color: Colors.blue.withOpacity(0.5), // Added opacity
              borderColor: kWhite, // Used your Kwhite color
              borderStrokeWidth: 2,
              radius: 1000, // This is in meters
              useRadiusInMeter: true,
            ),
            
          ]),
           
            
          ],
        ),
      ),
    );
  }
}
