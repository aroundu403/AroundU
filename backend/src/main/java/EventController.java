// This class will control the event modules with database

import DAO.Event;
import org.apache.commons.lang3.NotImplementedException;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

public class EventController {

    private static final String TABLE_NAME = "events";

    /**
     * Created and inserted the event into the database and returns the id for that event
     * @param pool used for database connection
     * @param event the event to be created
     * @return event_id for this event
     * @throws SQLException
     */
    public static long createEvent(DataSource pool, Event event) throws SQLException {
        long id = 0;
        try (Connection conn = pool.getConnection()) {
          String stmt = String.format(
                  "INSERT INTO %s (event_code, event_name, description, host_id, isPublic, location_name, latitude, " +
                   "longitude, start_time, end_time, max_participants, curr_num_participants, photoID, address) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", TABLE_NAME);
          try(PreparedStatement createEventStmt = conn.prepareStatement(stmt)) {
              createEventStmt.setString(1, event.event_code);
              createEventStmt.setString(2, event.event_name);
              createEventStmt.setString(3, event.description);
              createEventStmt.setString(4, event.host_id);
              createEventStmt.setInt(5, event.isPublic);
              createEventStmt.setString(6, event.location_name);
              createEventStmt.setFloat(7, event.latitude);
              createEventStmt.setFloat(8, event.longitude);
              createEventStmt.setTimestamp(9, event.start_time);
              createEventStmt.setTimestamp(10, event.end_time);
              createEventStmt.setInt(11, event.max_participants);
              createEventStmt.setInt(121, event.curr_num_participants);
              createEventStmt.setString(13, event.photoID);
              createEventStmt.setString(14, event.address);
              createEventStmt.setTimestamp(15, new Timestamp(System.currentTimeMillis()));
              createEventStmt.executeUpdate();
          }
          try (PreparedStatement getIDStmt = conn.prepareStatement("SELECT LAST_INSERT_ID() from events")) {
              ResultSet idResults = getIDStmt.executeQuery();
              if (idResults.next()) {
                  id = idResults.getInt(1);
                  idResults.close();
              }
          }
        }
        return id;
    }


    /**
     * Retries and returns the event based on the given event_id
     * @param pool used for database connection
     * @param event_id the unique representation of an event
     * @return the event associated with that id
     * @throws SQLException
     */
    public static Event getEventByID(DataSource pool, long event_id) throws SQLException {
        Event event = new Event();
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "SELECT event_id, event_code, event_name, description, host_id, isPublic, location_name, latitude, longitude, " +
                            "start_time, end_time, max_participants, curr_num_participants, photoID, address, created_at" +
                            " FROM %s WHERE event_id = ?",
                    TABLE_NAME);
            try(PreparedStatement getEventStmt = conn.prepareStatement(stmt)) {
                getEventStmt.setLong(1, event_id);
                ResultSet eventResults = getEventStmt.executeQuery();
                while (eventResults.next()) {
                    event.event_id = eventResults.getLong(1);
                    event.event_code = eventResults.getString(2);
                    event.event_name = eventResults.getString(3);
                    event.description = eventResults.getString(4);
                    event.host_id = eventResults.getString(5);
                    event.isPublic = eventResults.getInt(6);
                    event.location_name = eventResults.getString(7);
                    event.latitude = eventResults.getFloat(8);
                    event.longitude = eventResults.getFloat(9);
                    event.start_time = eventResults.getTimestamp(10);
                    event.end_time = eventResults.getTimestamp(11);
                    event.max_participants = eventResults.getInt(12);
                    event.curr_num_participants = eventResults.getInt(13);
                    event.photoID = eventResults.getString(14);
                    event.address = eventResults.getString(15);
                    event.created_at = eventResults.getTimestamp(16);
                }
                eventResults.close();
                return event;
            }
        }
    }

    /**
     * Update the event details associated with that id
     * @param pool used for database connection
     * @param event the updated event
     * @return the event_id of the updated event, or exception if error occurs
     */
    public static long updateEvent(DataSource pool, Event event) throws SQLException {
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "UPDATE %s SET event_name = ?, description = ?, isPublic = ?, location_name = ?, " +
                            "latitude = ?, longitude = ?, start_time = ?, end_time = ?, max_participants = ?, " +
                            "curr_num_participants = ?, photoID = ?, address = ?, updated_at = ? " +
                            "WHERE event_id = ?;", TABLE_NAME);
            try(PreparedStatement updateEventStmt = conn.prepareStatement(stmt)) {
                updateEventStmt.setString(1, event.event_name);
                updateEventStmt.setString(2, event.description);
                updateEventStmt.setInt(3, event.isPublic);
                updateEventStmt.setString(4, event.location_name);
                updateEventStmt.setFloat(5, event.latitude);
                updateEventStmt.setFloat(6, event.longitude);
                updateEventStmt.setTimestamp(7, event.start_time);
                updateEventStmt.setTimestamp(8, event.end_time);
                updateEventStmt.setInt(9, event.max_participants);
                updateEventStmt.setInt(10, event.curr_num_participants);
                updateEventStmt.setString(11, event.photoID);
                updateEventStmt.setString(12, event.address);
                updateEventStmt.setTimestamp(13, new Timestamp(System.currentTimeMillis()));
                updateEventStmt.setLong(14, event.event_id);
                updateEventStmt.executeUpdate();
                return event.event_id;
            }
        }
    }

    /**
     * Delete the event associated with that id
     * @param pool used for database connection
     * @param event_id the unique representation of an event
     * @return true if that event is deleted successfully, returns false otherwise
     */
    public static boolean deleteEvent(DataSource pool, long event_id){
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "UPDATE %s SET  deleted_at = ? WHERE event_id = ?;", TABLE_NAME);
            try(PreparedStatement updateEventStmt = conn.prepareStatement(stmt)) {
                updateEventStmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                updateEventStmt.setLong(2, event_id);
                updateEventStmt.executeUpdate();
                return true;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Check whether the given event is existed
     * @param pool used for database connection
     * @param event_id unique representation of an event
     * @return returns true if this event already exists, returns false otherwise
     */
    public static boolean isEventExist(DataSource pool, long event_id) {
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "SELECT event_name FROM %s WHERE event_id = ?;",
                    TABLE_NAME);
            try(PreparedStatement isUserExistStmt = conn.prepareStatement(stmt)) {
                isUserExistStmt.setLong(1, event_id);
                ResultSet eventResult = isUserExistStmt.executeQuery();
                if (eventResult.next()) {
                    eventResult.close();
                    return true;
                } else {
                    eventResult.close();
                    return false;
                }
            }
        } catch (SQLException e){
            return false;
        }
    }
}
//long event_id, String event_code, String event_name,
//                                               String description, long host_id, boolean isPublic, String location_name,
//                                               float latitude, float longitude, int max_participants,
//                                               int curr_num_participants, String photoID, String address,
//                                               String title, String start_time, String end_time, String updated_at