/// This is a Dart class the models detialed event information created by Host
/// This will be a 1-1 mapping to the JSON data from backend API
class EventInfo {

  final int eventId;
  final String eventName;
  final String description;
  final String hostId; // the user id of the event creator
  final int isPublic; // 1 for public, 0 for private
  final int isDeleted; // 1 for deleted, 0 for not deleted

  // event location info
  final String locationName;
  final double latitude;
  final double longitude;
  final String address;

  // number of participant
  final int maxParticipants;
  final int currNumParticipants;

  final String startTime;
  final String endTime;
  final String createdAt;
  final List<String> participantIds;

  const EventInfo({
    required this.eventId,
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
    required this.address,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.participantIds, 
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
      eventId: json['event_id'],
      eventName: json['event_name'],
      description: json['description'],
      hostId: json['host_id'],
      isPublic: json['is_public'], 
      isDeleted: json['is_deleted'],

      locationName: json['location_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      maxParticipants: json['max_participants'],
      currNumParticipants: json['curr_num_participants'],

      address: json['address'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      createdAt: json['created_at'],
      participantIds: json.containsKey('participant_ids') ? List<String>.from(json['participant_ids']) : <String>[],
    );
  }
}
