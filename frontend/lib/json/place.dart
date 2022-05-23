// Objects that represent the entities for place search
import 'package:mapbox_gl/mapbox_gl.dart';

class Place {
  // address of the place. e.g. 4001 E Stevens Way NE, Seattle, WA 98195
  String address;
  // name of the place. e.g. Husky Union Building
  String name;
  // geo-location of the building e.g. (47.655548, -122.303200)
  LatLng location;

  Place({
    required this.address,
    required this.name,
    required this.location,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      address: json["formatted_address"],
      name: json["name"],
      location: LatLng(json["geometry"]["location"]["lat"], json["geometry"]["location"]["lng"]),
    );
  }
}

class AddressSuggestion {
  final String placeId;
  final String description;

  AddressSuggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
