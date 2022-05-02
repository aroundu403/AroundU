package DAO;

import lombok.Data;

import java.sql.Timestamp;
import java.util.Arrays;

@Data
public class Event {

    public long event_id;
    public String event_code;
    public String event_name;
    public String description;
    public long host_id;
    public boolean isPublic;
    public String location_name;
    public float latitude;
    public float longitude;
    public int max_participants;
    public int curr_num_participants;

    public String photoID;
    public String address;
    public String title;
    //public String type;

    public Timestamp start_time;
    public Timestamp end_time;
    public Timestamp created_at;
    public Timestamp deleted_at;
    public Timestamp updated_at;

    public Event(long id, String event_code, String event_name, String description, long creator_id, boolean isPublic,
                 String location_name, float latitude, float longitude, int max_participants, int curr_participants,
                 String photoID, String address, String title, Timestamp start_time, Timestamp end_time,
                 Timestamp created_at, Timestamp deleted_at, Timestamp updated_at) {
        this.event_id = id;
        this.event_code = event_code;
        this.event_name = event_name;
        this.description = description;
        this.host_id = creator_id;
        this.isPublic = isPublic;
        this.location_name = location_name;
        this.latitude = latitude;
        this.longitude = longitude;
        this.max_participants = max_participants;
        this.curr_num_participants = curr_participants;
        this.photoID = photoID;
        this.address = address;
        this.title = title;
        this.start_time = start_time;
        this.end_time = end_time;
        this.created_at = created_at;
        this.deleted_at = deleted_at;
        this.updated_at = updated_at;
    }

//    public long getId() {
//        return id;
//    }
//
//    public String getEvent_code() {
//        return event_code;
//    }
//
//    public void setEvent_code(String event_code) {
//        this.event_code = event_code;
//    }
//
//    public String getEvent_name() {
//        return event_name;
//    }
//
//    public void setEvent_name(String event_name) {
//        this.event_name = event_name;
//    }
//
//    public String getDescription() {
//        return description;
//    }
//
//    public void setDescription(String description) {
//        this.description = description;
//    }
//
//    public long getCreator_id() {
//        return creator_id;
//    }
//
//    public void setCreator_id(long creator_id) {
//        this.creator_id = creator_id;
//    }
//
//    public boolean isPublic() {
//        return IsPublic;
//    }
//
//    public void setPublic(boolean aPublic) {
//        IsPublic = aPublic;
//    }
//
//    public String getLocation_name() {
//        return location_name;
//    }
//
//    public void setLocation_name(String location_name) {
//        this.location_name = location_name;
//    }
//
//    public float getLatitude() {
//        return latitude;
//    }
//
//    public void setLatitude(float latitude) {
//        this.latitude = latitude;
//    }
//
//    public float getLongitude() {
//        return longitude;
//    }
//
//    public void setLongitude(float longitude) {
//        this.longitude = longitude;
//    }
//
//    public int getMax_participants() {
//        return max_participants;
//    }
//
//    public void setMax_participants(int max_participants) {
//        this.max_participants = max_participants;
//    }
//
//    public int getCurr_participants() {
//        return curr_participants;
//    }
//
//    public void setCurr_participants(int curr_participants) {
//        this.curr_participants = curr_participants;
//    }
//
//    public long getPhotoID() {
//        return photoID;
//    }
//
//    public void setPhotoID(long photoID) {
//        this.photoID = photoID;
//    }
//
//    public String getAddress() {
//        return address;
//    }
//
//    public long[] getParticipants() {
//        return participants;
//    }
//
//    public void setParticipants(long[] participants) {
//        this.participants = participants;
//    }
//
//    public void setAddress(String address) {
//        this.address = address;
//    }
//
//    public String getTitle() {
//        return title;
//    }
//
//    public void setTitle(String title) {
//        this.title = title;
//    }
//
//    public String getType() {
//        return type;
//    }
//
//    public void setType(String type) {
//        this.type = type;
//    }
//
//    public Timestamp getStart_time() {
//        return start_time;
//    }
//
//    public void setStart_time(Timestamp start_time) {
//        this.start_time = start_time;
//    }
//
//    public Timestamp getEnd_time() {
//        return end_time;
//    }
//
//    public void setEnd_time(Timestamp end_time) {
//        this.end_time = end_time;
//    }
//
//    public Timestamp getCreated_at() {
//        return created_at;
//    }
//
//    public void setCreated_at(Timestamp created_at) {
//        this.created_at = created_at;
//    }
//
//    public Timestamp getDeleted_at() {
//        return deleted_at;
//    }
//
//    public void setDeleted_at(Timestamp deleted_at) {
//        this.deleted_at = deleted_at;
//    }
//
//    public Timestamp getUpdated_at() {
//        return updated_at;
//    }
//
//    public void setUpdated_at(Timestamp updated_at) {
//        this.updated_at = updated_at;
//    }

    @Override
    public String toString() {
        return "DAO.Event{" +
                "id=" + event_id +
                ", event_code='" + event_code + '\'' +
                ", event_name='" + event_name + '\'' +
                ", description='" + description + '\'' +
                ", creator_id=" + host_id +
                ", IsPublic=" + isPublic +
                ", location_name='" + location_name + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", max_participants=" + max_participants +
                ", photoID=" + photoID +
                ", address='" + address + '\'' +
                ", title='" + title + '\'' +
                ", start_time=" + start_time +
                ", end_time=" + end_time +
                ", created_at=" + created_at +
                ", deleted_at=" + deleted_at +
                ", updated_at=" + updated_at +
                '}';
    }


}
