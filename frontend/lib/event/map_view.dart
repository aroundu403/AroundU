/// This is the map-view widget of AroundU which is responsible for displaying the recent events on a map view
/// This widget will invoke the MapBox Flutter library to render the map view. 
/// User can learn more about the events by clicking the icons on the map.
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../json/event.dart';
import 'event_detail.dart';
import 'api_calls.dart';

// MapBox style url which serves a map style configuration file
const styleString = 'mapbox://styles/johnwang66/cl2y95qa3000l15p6c38ppu7v';

class MapView extends StatefulWidget {
  const MapView({ Key? key, required this.enableControl }) : super(key: key);
  final bool enableControl;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapboxMapController? _mapController;

  _onStyleLoadedCallback() async {
    List<EventInfo> events = await fetchEvents();
    List<SymbolOptions> symbols = <SymbolOptions>[];
    List<Map<String, int>> symbolIds = <Map<String, int>>[];
    for (int i = 0; i < events.length; i++) {
      symbolIds.add({"eventId": events[i].eventId});
      symbols.add(
        SymbolOptions(
          iconImage: 'embassy',
          iconColor: '#006992',
          iconSize: 1.6,
          geometry: LatLng(events[i].latitude, events[i].longitude),
          textField: events[i].eventName,
          textMaxWidth: 10,
          textSize: 15,
          textColor: '#000000',
          textOffset: const Offset(0, -1.3),
        )
      );
    }
    _mapController!.addSymbols(symbols, symbolIds);
  }

  /// After map has been initialized, register controller and callback functions
  _onMapCreate(MapboxMapController controller) async {
    _mapController = controller;
    _mapController!.onSymbolTapped.add(_onSymbolTapped);
  }

  void _onSymbolTapped(Symbol symbol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(eventId: symbol.data!['eventId']),
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
        dragEnabled: widget.enableControl,
        zoomGesturesEnabled: widget.enableControl,
      );
  }

  @override
  void dispose() {
    //_mapController!.dispose();
    super.dispose();
  }
}