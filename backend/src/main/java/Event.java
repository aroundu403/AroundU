import java.sql.Timestamp;
import java.util.Arrays;

public class Event {

    private final long id;
    private String event_code;
    private String event_name;
    private String description;
    private long creator_id;
    private boolean IsPublic;
    private String location_name;
    private float latitude;
    private float longitude;
    private int max_participants;
    private int curr_participants;

    private long photoID;
    private String address;
    private String title;
    private String type;
    private String[] participants;

    private Timestamp start_time;
    private Timestamp end_time;
    private Timestamp created_at;
    private Timestamp deleted_at;
    private Timestamp updated_at;

    public Event(String[] participants, long id, String event_code, String event_name, String description, long creator_id, boolean isPublic, String location_name, float latitude, float longitude, int max_participants, int curr_participants, long photoID, String address, String title, String type, Timestamp start_time, Timestamp end_time, Timestamp created_at, Timestamp deleted_at, Timestamp updated_at) {
        this.id = id;
        this.event_code = event_code;
        this.event_name = event_name;
        this.description = description;
        this.creator_id = creator_id;
        IsPublic = isPublic;
        this.location_name = location_name;
        this.latitude = latitude;
        this.longitude = longitude;
        this.max_participants = max_participants;
        this.curr_participants = curr_participants;
        this.photoID = photoID;
        this.address = address;
        this.title = title;
        this.type = type;
        this.start_time = start_time;
        this.end_time = end_time;
        this.created_at = created_at;
        this.deleted_at = deleted_at;
        this.updated_at = updated_at;
        this.participants = participants;
    }

    public long getId() {
        return id;
    }

    public String getEvent_code() {
        return event_code;
    }

    public void setEvent_code(String event_code) {
        this.event_code = event_code;
    }

    public String getEvent_name() {
        return event_name;
    }

    public void setEvent_name(String event_name) {
        this.event_name = event_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getCreator_id() {
        return creator_id;
    }

    public void setCreator_id(long creator_id) {
        this.creator_id = creator_id;
    }

    public boolean isPublic() {
        return IsPublic;
    }

    public void setPublic(boolean aPublic) {
        IsPublic = aPublic;
    }

    public String getLocation_name() {
        return location_name;
    }

    public void setLocation_name(String location_name) {
        this.location_name = location_name;
    }

    public float getLatitude() {
        return latitude;
    }

    public void setLatitude(float latitude) {
        this.latitude = latitude;
    }

    public float getLongitude() {
        return longitude;
    }

    public void setLongitude(float longitude) {
        this.longitude = longitude;
    }

    public int getMax_participants() {
        return max_participants;
    }

    public void setMax_participants(int max_participants) {
        this.max_participants = max_participants;
    }

    public int getCurr_participants() {
        return curr_participants;
    }

    public void setCurr_participants(int curr_participants) {
        this.curr_participants = curr_participants;
    }

    public long getPhotoID() {
        return photoID;
    }

    public void setPhotoID(long photoID) {
        this.photoID = photoID;
    }

    public String getAddress() {
        return address;
    }

    public String[] getParticipants() {
        return participants;
    }

    public void setParticipants(String[] participants) {
        this.participants = participants;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Timestamp getStart_time() {
        return start_time;
    }

    public void setStart_time(Timestamp start_time) {
        this.start_time = start_time;
    }

    public Timestamp getEnd_time() {
        return end_time;
    }

    public void setEnd_time(Timestamp end_time) {
        this.end_time = end_time;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getDeleted_at() {
        return deleted_at;
    }

    public void setDeleted_at(Timestamp deleted_at) {
        this.deleted_at = deleted_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    @Override
    public String toString() {
        return "Event{" +
                "id=" + id +
                ", event_code='" + event_code + '\'' +
                ", event_name='" + event_name + '\'' +
                ", description='" + description + '\'' +
                ", creator_id=" + creator_id +
                ", IsPublic=" + IsPublic +
                ", location_name='" + location_name + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", max_participants=" + max_participants +
                ", curr_participants=" + curr_participants +
                ", photoID=" + photoID +
                ", address='" + address + '\'' +
                ", title='" + title + '\'' +
                ", type='" + type + '\'' +
                ", participants=" + Arrays.toString(participants) +
                ", start_time=" + start_time +
                ", end_time=" + end_time +
                ", created_at=" + created_at +
                ", deleted_at=" + deleted_at +
                ", updated_at=" + updated_at +
                '}';
    }


}
