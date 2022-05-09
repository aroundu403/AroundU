package DAL; // This class will control the event modules with database

import DAO.Event;

import javax.sql.DataSource;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class EventController {

  private static final String TABLE_NAME = "events";
  private static final DateFormat SIMPLE_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  /**
   * Created and inserted the event into the database and returns the id for that event
   *
   * @param pool used for database connection
   * @param event the event to be created
   * @return event_id for this event
   * @throws SQLException
   */
  public static long createEvent(DataSource pool, Event event) throws SQLException {
    long id = 0;
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "INSERT INTO %s (event_code, event_name, description, host_id, isPublic, isDeleted, location_name, latitude, "
                  + "longitude, start_time, end_time, max_participants, curr_num_participants, photoID, icon, address, created_at) "
                  + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
              TABLE_NAME);
      try (PreparedStatement createEventStmt = conn.prepareStatement(stmt)) {
        createEventStmt.setString(1, event.event_code);
        createEventStmt.setString(2, event.event_name);
        createEventStmt.setString(3, event.description);
        createEventStmt.setString(4, event.host_id);
        createEventStmt.setInt(5, event.isPublic);
        createEventStmt.setInt(6, event.isDeleted);

        createEventStmt.setString(7, event.location_name);
        createEventStmt.setFloat(8, event.latitude);
        createEventStmt.setFloat(9, event.longitude);
        createEventStmt.setTimestamp(10, Timestamp.valueOf(event.start_time));
        createEventStmt.setTimestamp(11, Timestamp.valueOf(event.end_time));
        createEventStmt.setInt(12, event.max_participants);
        createEventStmt.setInt(13, event.curr_num_participants);
        createEventStmt.setString(14, event.photoID);
        createEventStmt.setString(15, event.icon);
        createEventStmt.setString(16, event.address);
        createEventStmt.setTimestamp(17, new Timestamp(System.currentTimeMillis()));
        System.out.println(stmt);
        createEventStmt.executeUpdate();
      }
      try (PreparedStatement getIDStmt =
          conn.prepareStatement("SELECT LAST_INSERT_ID() from events")) {
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
   *
   * @param pool used for database connection
   * @param event_id the unique representation of an event
   * @return the event associated with that id
   * @throws SQLException
   */
  public static Event getEventByID(DataSource pool, long event_id) throws SQLException {
    Event event = new Event();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_id, event_code, event_name, description, host_id, isPublic, location_name, latitude, longitude, "
                  + "start_time, end_time, max_participants, curr_num_participants, photoID, icon, address, created_at"
                  + " FROM %s WHERE event_id = ?",
              TABLE_NAME);
      try (PreparedStatement getEventStmt = conn.prepareStatement(stmt)) {
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
          event.start_time = String.valueOf(eventResults.getTimestamp(10));
          event.end_time = String.valueOf(eventResults.getTimestamp(11));
          event.max_participants = eventResults.getInt(12);
          event.curr_num_participants = eventResults.getInt(13);
          event.photoID = eventResults.getString(14);
          event.icon = eventResults.getString(15);
          event.address = eventResults.getString(16);
          event.created_at = String.valueOf(eventResults.getTimestamp(17));
        }
        eventResults.close();
        return event;
      }
    }
  }

  /**
   * Update the event details associated with that id
   *
   * @param pool used for database connection
   * @param event the updated event
   * @return the event_id of the updated event, or exception if error occurs
   */
  public static long updateEvent(DataSource pool, Event event) throws SQLException {
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "UPDATE %s SET event_name = ?, description = ?, isPublic = ?, location_name = ?, "
                  + "latitude = ?, longitude = ?, start_time = ?, end_time = ?, max_participants = ?, "
                  + "curr_num_participants = ?, photoID = ?, address = ?, updated_at = ?, icon = ?"
                  + "WHERE event_id = ?;",
              TABLE_NAME);
      try (PreparedStatement updateEventStmt = conn.prepareStatement(stmt)) {
        updateEventStmt.setString(1, event.event_name);
        updateEventStmt.setString(2, event.description);
        updateEventStmt.setInt(3, event.isPublic);
        updateEventStmt.setString(4, event.location_name);
        updateEventStmt.setFloat(5, event.latitude);
        updateEventStmt.setFloat(6, event.longitude);
        updateEventStmt.setTimestamp(7, Timestamp.valueOf(event.start_time));
        updateEventStmt.setTimestamp(8, Timestamp.valueOf(event.end_time));
        updateEventStmt.setInt(9, event.max_participants);
        updateEventStmt.setInt(10, event.curr_num_participants);
        updateEventStmt.setString(11, event.photoID);
        updateEventStmt.setString(12, event.address);
        updateEventStmt.setTimestamp(13, new Timestamp(System.currentTimeMillis()));
        updateEventStmt.setString(14, event.icon);
        updateEventStmt.setLong(15, event.event_id);
        updateEventStmt.executeUpdate();
        return event.event_id;
      }
    }
  }

  /**
   * Delete the event associated with that id
   *
   * @param pool used for database connection
   * @param event_id the unique representation of an event
   * @return true if that event is deleted successfully, returns false otherwise
   */
  public static boolean deleteEvent(DataSource pool, long event_id) {
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "UPDATE %s SET deleted_at = ?, isDeleted = ? WHERE event_id = ?;", TABLE_NAME);
      try (PreparedStatement updateEventStmt = conn.prepareStatement(stmt)) {
        updateEventStmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
        updateEventStmt.setInt(2, 1);
        updateEventStmt.setLong(3, event_id);
        updateEventStmt.executeUpdate();
        return true;
      }
    } catch (SQLException e) {
      return false;
    }
  }

  /**
   * Check whether the given event is existed
   *
   * @param pool used for database connection
   * @param event_id unique representation of an event
   * @return returns true if this event already exists, returns false otherwise
   */
  public static boolean isEventExist(DataSource pool, long event_id) {
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_name FROM %s WHERE (event_id = ?) AND (isDeleted != 1);", TABLE_NAME);
      try (PreparedStatement isUserExistStmt = conn.prepareStatement(stmt)) {
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
    } catch (SQLException e) {
      return false;
    }
  }

  /**
   * Returns a list of event ids of events that will start within the next n days
   *
   * @param pool used for database connection
   * @param nDay next n days
   * @return A list of event ids of events that will start within the next n days
   * @throws SQLException
   */
  public static ArrayList<Long> getEventsInNextNDays(DataSource pool, int nDay)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format("SELECT event_id FROM %s WHERE start_time BETWEEN ? and ?;", TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        Calendar c = Calendar.getInstance();
        c.setTime(new Date()); // Now use today date.
        String start_date = SIMPLE_DATE_FORMAT.format(c.getTime());
        c.add(Calendar.DATE, nDay); // Adding n days
        String end_date = SIMPLE_DATE_FORMAT.format(c.getTime());

        getEventsStmt.setString(1, start_date);
        getEventsStmt.setString(2, end_date);
        ResultSet eventResult = getEventsStmt.executeQuery();

        while (eventResult.next()) {
          eventIDs.add(eventResult.getLong(1));
        }
        return eventIDs;
      }
    }
  }
}
