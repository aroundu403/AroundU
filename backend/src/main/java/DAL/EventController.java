package DAL; // This class will control the event modules with database

import DAO.Event;
import DAO.Location;
import org.apache.commons.lang3.NotImplementedException;

import javax.sql.DataSource;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

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
              "INSERT INTO %s (event_code, event_name, description, host_id, is_public, is_deleted, location_name, latitude, "
                  + "longitude, start_time, end_time, max_participants, curr_num_participants, address, created_at) "
                  + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
              TABLE_NAME);
      try (PreparedStatement createEventStmt = conn.prepareStatement(stmt)) {
        createEventStmt.setString(1, event.event_code);
        createEventStmt.setString(2, event.event_name);
        createEventStmt.setString(3, event.description);
        createEventStmt.setString(4, event.host_id);
        createEventStmt.setInt(5, event.is_public);
        createEventStmt.setInt(6, event.is_deleted);
        createEventStmt.setString(7, event.location_name);
        createEventStmt.setFloat(8, event.latitude);
        createEventStmt.setFloat(9, event.longitude);
        createEventStmt.setTimestamp(10, Timestamp.valueOf(event.start_time));
        createEventStmt.setTimestamp(11, Timestamp.valueOf(event.end_time));
        createEventStmt.setInt(12, event.max_participants);
        createEventStmt.setInt(13, event.curr_num_participants);
        createEventStmt.setString(14, event.address);
        createEventStmt.setTimestamp(15, new Timestamp(System.currentTimeMillis()));
        createEventStmt.executeUpdate();
        resetIdIndex(pool);
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
              "SELECT event_id, event_code, event_name, description, host_id, is_public, location_name, latitude, longitude, "
                  + "start_time, end_time, max_participants, curr_num_participants, photo_id, icon, address, created_at"
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
          event.is_public = eventResults.getInt(6);
          event.location_name = eventResults.getString(7);
          event.latitude = eventResults.getFloat(8);
          event.longitude = eventResults.getFloat(9);
          event.start_time = String.valueOf(eventResults.getTimestamp(10));
          event.end_time = String.valueOf(eventResults.getTimestamp(11));
          event.max_participants = eventResults.getInt(12);
          event.curr_num_participants = eventResults.getInt(13);
          event.photo_id = eventResults.getString(14);
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
              "UPDATE %s SET event_name = ?, description = ?, is_public = ?, location_name = ?, "
                  + "latitude = ?, longitude = ?, start_time = ?, end_time = ?, max_participants = ?, "
                  + "curr_num_participants = ?, photo_id = ?, address = ?, updated_at = ?, icon = ?"
                  + "WHERE event_id = ?;",
              TABLE_NAME);
      try (PreparedStatement updateEventStmt = conn.prepareStatement(stmt)) {
        updateEventStmt.setString(1, event.event_name);
        updateEventStmt.setString(2, event.description);
        updateEventStmt.setInt(3, event.is_public);
        updateEventStmt.setString(4, event.location_name);
        updateEventStmt.setFloat(5, event.latitude);
        updateEventStmt.setFloat(6, event.longitude);
        updateEventStmt.setTimestamp(7, Timestamp.valueOf(event.start_time));
        updateEventStmt.setTimestamp(8, Timestamp.valueOf(event.end_time));
        updateEventStmt.setInt(9, event.max_participants);
        updateEventStmt.setInt(10, event.curr_num_participants);
        updateEventStmt.setString(11, event.photo_id);
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
              "UPDATE %s SET deleted_at = ?, is_deleted = ? WHERE event_id = ?;", TABLE_NAME);
      try (PreparedStatement updateEventStmt = conn.prepareStatement(stmt)) {
        updateEventStmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
        updateEventStmt.setInt(2, 1);
        updateEventStmt.setLong(3, event_id);
        updateEventStmt.executeUpdate();
        resetIdIndex(pool);
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
              "SELECT event_name FROM %s WHERE (event_id = ?) AND (is_deleted != 1);", TABLE_NAME);
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
        Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
        c.add(Calendar.HOUR, -8);
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

  /**
   * Returns a list of event_ids will start within the next 14 days within the current mapbox
   *
   * @param pool used for database connection
   * @param topLeft on the mapbox
   * @param topRight on the mapbox
   * @param botLeft on the mapbox
   * @param botRight on the mapbox
   * @return a list of event_ids
   * @throws SQLException
   */
  public static ArrayList<Long> getEventsInMapBox(
      DataSource pool, Location topLeft, Location topRight, Location botLeft, Location botRight)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_id FROM %s WHERE latitude BETWEEN ? and ? AND longitude BETWEEN ? and ?;",
              TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        getEventsStmt.setFloat(1, topLeft.longitude);
        getEventsStmt.setFloat(2, topRight.longitude);
        getEventsStmt.setFloat(3, botLeft.latitude);
        getEventsStmt.setFloat(2, topLeft.latitude);
        ResultSet eventResults = getEventsStmt.executeQuery();

        while (eventResults.next()) {
          eventIDs.add(eventResults.getLong(1));
        }

        ArrayList<Long> eventIDIn2Weeks = getEventsInNextNDays(pool, 14);
        eventIDs.retainAll(eventIDIn2Weeks);
        return eventIDs;
      }
    }
  }

  /**
   * Returns a list of event_ids will start within the next two weeks within the number of given
   * miles
   *
   * @param pool used for database connection
   * @param location the given location
   * @param miles the range to search
   * @return a list of event_ids
   * @throws SQLException
   */
  public static ArrayList<Long> getNearbyEvents(DataSource pool, Location location, int miles)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_id,\n"
                  + " ( 3959 * acos( cos( radians(?)) cos(radians(latitude)) * cos(radians(longitude) - radians(?) )\n"
                  + "  + sin( radians(?) ) * sin( radians( latitude ) ) ) ) AS distance FROM %s HAVING distance < ?;",
              TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        getEventsStmt.setFloat(1, location.latitude);
        getEventsStmt.setFloat(2, location.longitude);
        getEventsStmt.setFloat(3, location.latitude);
        getEventsStmt.setInt(4, miles);
        ResultSet eventResults = getEventsStmt.executeQuery();
        while (eventResults.next()) {
          eventIDs.add(eventResults.getLong(1));
          double distance = eventResults.getDouble(2);
        }
      }
      ArrayList<Long> eventIDIn2Weeks = getEventsInNextNDays(pool, 14);
      eventIDs.retainAll(eventIDIn2Weeks);
      return eventIDs;
    }
  }

  /**
   * Returns a list of future event_id that is at a geo location.
   *
   * @param pool used for database connection
   * @param location_name the location name given
   * @return a list of events
   */
  public static ArrayList<Long> getEventsByLocation(DataSource pool, String location_name)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_id FROM %s WHERE location_name = ? AND is_deleted = 0;", TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        getEventsStmt.setString(1, location_name);
        ResultSet eventResults = getEventsStmt.executeQuery();
        while (eventResults.next()) {
          eventIDs.add(eventResults.getLong(1));
        }
        eventResults.close();
      }
      ArrayList<Long> eventIDIn2Weeks = getEventsInNextNDays(pool, 14);
      eventIDs.retainAll(eventIDIn2Weeks);
      return eventIDs;
    }
  }

  /**
   * Returns a list of future event_id that is at a geo location.
   *
   * @param pool used for database connection
   * @param max_participants the max number of participants
   * @return a list of events
   */
  public static ArrayList<Long> getEventsByMaxPar(DataSource pool, int max_participants)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_id FROM %s WHERE max_participants <= ? AND is_deleted = 0;",
              TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        getEventsStmt.setInt(1, max_participants);
        ResultSet eventResults = getEventsStmt.executeQuery();
        while (eventResults.next()) {
          eventIDs.add(eventResults.getLong(1));
        }
        eventResults.close();
      }
      ArrayList<Long> eventIDIn2Weeks = getEventsInNextNDays(pool, 14);
      eventIDs.retainAll(eventIDIn2Weeks);
      return eventIDs;
    }
  }

  /**
   * Returns a list of event_id that a host created
   *
   * @param pool used for database connection
   * @param host_id the unique representation of a user
   * @return a list of events
   */
  public static ArrayList<Long> getEventsByHost(DataSource pool, String host_id)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_id FROM %s WHERE host_id = ? AND is_deleted = 0;", TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        getEventsStmt.setString(1, host_id);
        ResultSet eventResults = getEventsStmt.executeQuery();
        while (eventResults.next()) {
          eventIDs.add(eventResults.getLong(1));
        }
        eventResults.close();
      }
      return eventIDs;
    }
  }

  /**
   * Returns a list future of event_id that a host created
   *
   * @param pool used for database connection
   * @param keyword the keyword given for searching event
   * @return a list of events
   */
  public static ArrayList<Long> getEventsByKeyWord(DataSource pool, String keyword)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT event_id FROM %s WHERE event_name LIKE ? AND is_deleted = 0;", TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        getEventsStmt.setString(1, "%" + keyword + "%");
        ResultSet eventResults = getEventsStmt.executeQuery();
        while (eventResults.next()) {
          eventIDs.add(eventResults.getLong(1));
        }
        eventResults.close();
      }
      ArrayList<Long> eventIDIn2Weeks = getEventsInNextNDays(pool, 14);
      eventIDs.retainAll(eventIDIn2Weeks);
      return eventIDs;
    }
  }

  /**
   * Reset the auto_increment index of the table
   *
   * @param pool used for database connection
   * @throws SQLException
   */
  public static void resetIdIndex(DataSource pool) throws SQLException {
    try (Connection conn = pool.getConnection()) {
      PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(event_id) FROM events;");
      ResultSet countResult = countStmt.executeQuery();
      countResult.next();
      int cardinality = countResult.getInt(1);
      PreparedStatement resetIndexStmt =
          conn.prepareStatement("ALTER TABLE events AUTO_INCREMENT = ?;");
      resetIndexStmt.setInt(1, cardinality + 1);
      resetIndexStmt.executeUpdate();
    }
  }
}
