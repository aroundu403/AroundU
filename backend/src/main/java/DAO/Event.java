package DAO;

import java.sql.Timestamp;
import java.util.List;

// Data representation of an event
public class Event {

  public long event_id;
  public String event_code;
  public String event_name;
  public String description;
  public String host_id;
  public int is_public; // 1 for public, 0 for private
  public int is_deleted; // 1 for deleted, 0 for not deleted

  public String location_name;
  public float latitude;
  public float longitude;
  public int max_participants;
  public int curr_num_participants;

  public String photo_id;
  public String icon;
  public String address;
  // public String type;

  public String start_time;
  public String end_time;
  public String created_at;
  public String deleted_at;
  public String updated_at;
  public List<String> participant_ids;

  public Event() {}

  public Event(
      long id,
      String event_code,
      String event_name,
      String description,
      String creator_id,
      int is_public,
      String location_name,
      float latitude,
      float longitude,
      int max_participants,
      int curr_participants,
      String photo_id,
      String address,
      Timestamp start_time,
      Timestamp end_time,
      Timestamp created_at,
      Timestamp deleted_at,
      Timestamp updated_at) {

    this.event_id = id;
    this.event_code = event_code;
    this.event_name = event_name;
    this.description = description;
    this.host_id = creator_id;
    this.is_public = is_public;
    this.location_name = location_name;
    this.latitude = latitude;
    this.longitude = longitude;
    this.max_participants = max_participants;
    this.curr_num_participants = curr_participants;
    this.photo_id = photo_id;
    this.address = address;
    this.start_time = String.valueOf(start_time);
    this.end_time = String.valueOf(end_time);
    this.created_at = String.valueOf(created_at);
    this.deleted_at = String.valueOf(deleted_at);
    this.updated_at = String.valueOf(updated_at);
  }

  @Override
  public String toString() {
    return "DAO.Event{"
        + "id="
        + event_id
        + ", event_code='"
        + event_code
        + '\''
        + ", event_name='"
        + event_name
        + '\''
        + ", description='"
        + description
        + '\''
        + ", creator_id="
        + host_id
        + ", IsPublic="
        + is_public
        + ", location_name='"
        + location_name
        + '\''
        + ", latitude="
        + latitude
        + ", longitude="
        + longitude
        + ", max_participants="
        + max_participants
        + ", photoID="
        + photo_id
        + ", address='"
        + address
        + '\''
        + ", start_time="
        + start_time
        + ", end_time="
        + end_time
        + ", created_at="
        + created_at
        + ", deleted_at="
        + deleted_at
        + ", updated_at="
        + updated_at
        + '}';
  }
}
