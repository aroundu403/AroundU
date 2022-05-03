// This class will control the event modules with database

import DAO.Event;
import org.apache.commons.lang3.NotImplementedException;

import javax.sql.DataSource;
import java.util.*;

public class EventController {

    private final String TABLE_NAME = "events";

    public static long createEvent(DataSource pool, String event_code, String event_name, String description,
                                   long host_id, boolean isPublic, String location_name, float latitude, float longitude,
                                   int max_participants, int curr_num_participants, String photoID, String address,
                                   String title, String start_time, String end_time, String created_at,
                                   String deleted_at, String updated_at) {

        throw new NotImplementedException();
    }

    public static Event getEvent(DataSource pool, long event_id) {
        throw new NotImplementedException();
    }

    public static long updateEvent(DataSource pool, long event_id, String event_code, String event_name,
                                               String description, long host_id, boolean isPublic, String location_name,
                                               float latitude, float longitude, int max_participants,
                                               int curr_num_participants, String photoID, String address,
                                               String title, String start_time, String end_time, String updated_at) {
        throw new NotImplementedException();

    }

    public static boolean deleteEvent(DataSource pool, long event_id) {
        throw new NotImplementedException();
    }
}
