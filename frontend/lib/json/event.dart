class EventInfo {
  final int eventId;
  final String eventName;
  final String description;
  final double latitude;
  final double longtitude;

  const EventInfo({
    required this.eventId,
    required this.eventName,
    required this.description,
    required this.latitude, 
    required this.longtitude,
  });
  
  factory EventInfo.fromJson(Map<String, dynamic> json) {
    print(EventInfo(
      latitude: json['latitude'],
      longtitude: json ['longitude'],
      eventId: json['event_id'], 
      eventName: json['event_name'],
      description: json['description']
    ).toString());
    return EventInfo(
      latitude: json['latitude'],
      longtitude: json ['longitude'],
      eventId: json['event_id'], 
      eventName: json['event_name'],
      description: json['description']
    );
  }
}