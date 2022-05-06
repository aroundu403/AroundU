
import 'dart:math';

import 'package:aroundu/event/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

const styleString = 'mapbox://styles/mapbox/streets-v11';

class MapView extends StatefulWidget {
  const MapView({ Key? key }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapboxMapController? _mapController;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MapboxMap(
        accessToken: dotenv.env['mapBoxAccessToken']!,
        styleString: styleString,
        minMaxZoomPreference: const MinMaxZoomPreference(6.0, null),

        // Initial center of the map to UW
        initialCameraPosition: const CameraPosition(
          zoom: 14.0,
          target: LatLng(47.6555, -122.3092),
        ),

        // When the map is created, move the map to the center of user's location
        onMapCreated: (MapboxMapController controller) async {
          _mapController = controller;
          // Acquire current location (returns the LatLng instance)
          final location = await acquireCurrentLocation();
          
          await controller.animateCamera(
            CameraUpdate.newLatLng(location!),
          );

          // Add a circle denoting current user location
          await controller.addCircle(
            CircleOptions(
              circleRadius: 8.0,
              circleColor: '#006992',
              circleOpacity: 0.8,
              geometry: location,
              draggable: false,
            ),
          );
        },
        
        // add a symbol when user clicks on the map
        onMapClick: (Point<double> point, LatLng coordinates) async {
          await _mapController!.addSymbol(
            SymbolOptions(
              iconImage: 'embassy-15',
              iconColor: '#006992',
              geometry: coordinates,
            ),
          );
        },
      ),

      // recenter map based on user's current loaction
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_on_sharp),
        onPressed: () async {
          final location = await acquireCurrentLocation();
          _mapController!.animateCamera(CameraUpdate.newLatLng(location!));
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }
}