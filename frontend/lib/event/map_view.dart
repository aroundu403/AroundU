
import 'dart:math';

import 'package:aroundu/event/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'eventdetail.dart';

const styleString = 'mapbox://styles/johnwang66/cl2y95qa3000l15p6c38ppu7v';

const events = [
  LatLng(47.655, -122.305),
  LatLng(47.653, -122.310),
  LatLng(47.657, -122.306),
];

const eventNames = [
  "Game Night",
  "Ski Carpool",
  "Boba Meetup"
];

class MapView extends StatefulWidget {
  const MapView({ Key? key }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapboxMapController? _mapController;

  _onStyleLoadedCallback() async {
<<<<<<< HEAD
=======
    int i = 0;
>>>>>>> map-view-2
    for (LatLng event in events) {
      await _mapController!.addSymbol(
        SymbolOptions(
          iconImage: 'embassy',
          iconColor: '#006992',
          iconSize: 2.0,
          geometry: event,
<<<<<<< HEAD
          textField: "Event 1",
=======
          textField: eventNames[i],
>>>>>>> map-view-2
          textColor: '#000000',
          textOffset: const Offset(0, -1.4),
        ),
      );
<<<<<<< HEAD
=======
      i++;
>>>>>>> map-view-2
    }
  }

  _onMapCreate(MapboxMapController controller) async {
    _mapController = controller;
    _mapController!.onSymbolTapped.add(_onSymbolTapped);
    // Acquire current location (returns the LatLng instance)
    final location = await acquireCurrentLocation();
    
    await controller.animateCamera(
      CameraUpdate.newLatLng(location!),
    );
  }

  void _onSymbolTapped(Symbol symbol) {
<<<<<<< HEAD
    print(123);
=======
>>>>>>> map-view-2
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EventPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MapboxMap(
        accessToken: dotenv.env['mapBoxAccessToken']!,
        styleString: styleString,
<<<<<<< HEAD
        minMaxZoomPreference: const MinMaxZoomPreference(6.0, null),
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
=======
        minMaxZoomPreference: const MinMaxZoomPreference(6.0, 16.0),
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        attributionButtonPosition: AttributionButtonPosition.TopLeft,
>>>>>>> map-view-2

        // Initial center of the map to UW
        initialCameraPosition: const CameraPosition(
          zoom: 14.0,
          target: LatLng(47.6555, -122.3092),
        ),

        onMapCreated: _onMapCreate,
        onStyleLoadedCallback: _onStyleLoadedCallback,
      ),

      // recenter map based on user's current loaction
<<<<<<< HEAD
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () async {
          final location = await acquireCurrentLocation();
          _mapController!.animateCamera(CameraUpdate.newLatLng(location!));
        },
      ),
=======
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.my_location),
      //   onPressed: () async {
      //     final location = await acquireCurrentLocation();
      //     _mapController!.animateCamera(CameraUpdate.newLatLng(location!));
      //   },
      // ),
>>>>>>> map-view-2
    );
  }

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }
}