/// This is the map-view widget of AroundU which is responsible for displaying the recent events on a map view
/// This widget will invoke the MapBox Flutter library to render the map view. 
/// User can learn more about the events by clicking the icons on the map.
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'event_detail.dart';

// MapBox style url which serves a map style configuration file
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
    int i = 0;
    for (LatLng event in events) {
      await _mapController!.addSymbol(
        SymbolOptions(
          iconImage: 'embassy',
          iconColor: '#006992',
          iconSize: 2.0,
          geometry: event,
          textField: eventNames[i],
          textColor: '#000000',
          textOffset: const Offset(0, -1.4),
        ),
      );
      i++;
    }
  }

  /// After map has been initialized, register controller and callback functions
  _onMapCreate(MapboxMapController controller) async {
    _mapController = controller;
    _mapController!.onSymbolTapped.add(_onSymbolTapped);
    // // Acquire current location (returns the LatLng instance)
    // final location = await acquireCurrentLocation();
    
    // await controller.animateCamera(
    //   CameraUpdate.newLatLng(location!),
    // );
  }

  void _onSymbolTapped(Symbol symbol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EventPage(eventId: 3,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return MapboxMap(
        accessToken: dotenv.env['mapBoxAccessToken']!,
        styleString: styleString,
        minMaxZoomPreference: const MinMaxZoomPreference(6.0, 16.0),
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
        attributionButtonPosition: AttributionButtonPosition.TopLeft,

        // Initial center of the map to UW
        initialCameraPosition: const CameraPosition(
          zoom: 14.0,
          target: LatLng(47.6555, -122.3092),
        ),

        onMapCreated: _onMapCreate,
        onStyleLoadedCallback: _onStyleLoadedCallback,
      );
  }

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }
}