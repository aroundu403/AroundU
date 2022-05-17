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
  // final int userId;
  // final int id;
  // final String title;

  final int event_id;
  final String event_code;
  final String event_name;
  final String description;
  final String host_id;
  final int isPublic; // 1 for public, 0 for private
  final int isDeleted; // 1 for deleted, 0 for not deleted

  final String location_name;
  final double latitude;
  final double longitude;
  final int max_participants;
  final int curr_num_participants;

  final String photoID;
  final String icon;
  final String address;

  final String start_time;
  final String end_time;
  final String created_at;
  final String deleted_at;
  final String updated_at;

  const EventInfo({
    // required this.userId,
    // required this.id,
    // required this.title,
    required this.event_id,
    required this.event_code,
    required this.event_name,
    required this.description,
    required this.host_id,
    required this.isPublic, // 1 for public, 0 for private
    required this.isDeleted, // 1 for deleted, 0 for not deleted

    required this.location_name,
    required this.latitude,
    required this.longitude,
    required this.max_participants,
    required this.curr_num_participants,
    required this.photoID,
    required this.icon,
    required this.address,
    required this.start_time,
    required this.end_time,
    required this.created_at,
    required this.deleted_at,
    required this.updated_at,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
      // userId: json['userId'],
      // id: json['id'],
      // title: json['title'],

      event_id: json['event_id'],
      event_code: json['event_code'],
      event_name: json['event_name'],
      description: json['description'],
      host_id: json['host_id'],
      isPublic: json['isPublic'], // 1 for public, 0 for private
      isDeleted: json['isDeleted'], // 1 for deleted, 0 for not deleted

      location_name: json['location_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      max_participants: json['max_participants'],
      curr_num_participants: json['curr_num_participants'],

      photoID: json['photoID'],
      icon: json['icon'],
      address: json['address'],
      start_time: json['start_time'],
      end_time: json['end_time'],
      created_at: json['created_at'],
      deleted_at: json['deleted_at'],
      updated_at: json['updated_at'],
    );
  }
}
