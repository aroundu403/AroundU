// class EventInfo {
//   final int eventId;
//   final String eventName;
//   final String description;
//   final double latitude;
//   final double longtitude;

//   const EventInfo({
//     required this.eventId,
//     required this.eventName,
//     required this.description,
//     required this.latitude,
//     required this.longtitude,
//   });

//   factory EventInfo.fromJson(Map<String, dynamic> json) {
//     print(EventInfo(
//       latitude: json['latitude'],
//       longtitude: json ['longitude'],
//       eventId: json['event_id'],
//       eventName: json['event_name'],
//       description: json['description']
//     ).toString());
//     return EventInfo(
//       latitude: json['latitude'],
//       longtitude: json ['longitude'],
//       eventId: json['event_id'],
//       eventName: json['event_name'],
//       description: json['description']
//     );
//   }
// }
class EventInfo {

  final int eventId;
  final String eventCode;
  final String eventName;
  final String description;
  final String hostId;
  final int isPublic; // 1 for public, 0 for private
  final int isDeleted; // 1 for deleted, 0 for not deleted

  final String locationName;
  final double latitude;
  final double longitude;
  final int maxParticipants;
  final int currNumParticipants;

  final String photoID;
  final String icon;
  final String address;

  final String startTime;
  final String endTime;
  final String createdAt;

  const EventInfo({
    required this.eventId,
    required this.eventCode,
    required this.eventName,
    required this.description,
    required this.hostId,
    required this.isPublic, 
    required this.isDeleted,

    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.maxParticipants,
    required this.currNumParticipants,
    required this.photoID,
    required this.icon,
    required this.address,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
      eventId: json['event_id'],
      eventCode: json['event_code'],
      eventName: json['event_name'],
      description: json['description'],
      hostId: json['host_id'],
      isPublic: json['isPublic'], 
      isDeleted: json['isDeleted'],

      locationName: json['location_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      maxParticipants: json['max_participants'],
      currNumParticipants: json['curr_num_participants'],

      photoID: json['photoID'],
      icon: json['icon'],
      address: json['address'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      createdAt: json['created_at'],
    );
  }
}
