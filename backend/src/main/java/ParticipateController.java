// This class will control the participation modules with database

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;

public class ParticipateController {

  private static final String TABLE_NAME = "participate";

  /**
   * Returns a list of users_id participating that event
   *
   * @param pool used for database connection
   * @param event_id the unique representation of an event
   * @return a list of users
   */
  public static ArrayList<String> getUsersByEvent(DataSource pool, long event_id)
      throws SQLException {
    ArrayList<String> userIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt = String.format("SELECT user_id FROM %s WHERE event_id = ?;", TABLE_NAME);
      try (PreparedStatement getUsersStmt = conn.prepareStatement(stmt)) {
        getUsersStmt.setLong(1, event_id);
        ResultSet userResults = getUsersStmt.executeQuery();
        while (userResults.next()) {
          userIDs.add(userResults.getString(1));
        }
        userResults.close();
        return userIDs;
      }
    }
  }

  /**
   * Returns a list of event_id that a user is participating
   *
   * @param pool used for database connection
   * @param user_id the unique representation of a user
   * @return a list of events
   */
  public static ArrayList<Long> getEventsByUser(DataSource pool, String user_id)
      throws SQLException {
    ArrayList<Long> eventIDs = new ArrayList<>();
    try (Connection conn = pool.getConnection()) {
      String stmt = String.format("SELECT event_id FROM %s WHERE user_id = ?;", TABLE_NAME);
      try (PreparedStatement getEventsStmt = conn.prepareStatement(stmt)) {
        getEventsStmt.setString(1, user_id);
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
   * Returns the current number of users participating that event
   *
   * @param pool used for database connection
   * @param event_id the unique representation of an event
   * @return the current number of users in that event
   */
  public static int countParticipants(DataSource pool, long event_id) throws SQLException {
    int numParticipants = 0;
    try (Connection conn = pool.getConnection()) {
      String stmt = String.format("SELECT COUNT(user_id) FROM %s WHERE event_id = ?;", TABLE_NAME);
      try (PreparedStatement getCountStmt = conn.prepareStatement(stmt)) {
        getCountStmt.setLong(1, event_id);
        ResultSet countResults = getCountStmt.executeQuery();
        while (countResults.next()) {
          numParticipants = countResults.getInt(1);
        }
        countResults.close();
      }
      return numParticipants;
    }
  }

  /**
   * Add a user to an event
   *
   * @param pool used for database connection
   * @param user_id the unique representation of a user
   * @param event_id the unique representation of a user
   * @return true if that a user is added to an event successfully, returns false otherwise
   */
  public static boolean userParticipateEvent(DataSource pool, String user_id, long event_id) {
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "INSERT INTO %s (user_id, event_id, join_time) VALUES (?, ?, ?);", TABLE_NAME);
      try (PreparedStatement createEventStmt = conn.prepareStatement(stmt)) {
        createEventStmt.setString(1, user_id);
        createEventStmt.setLong(2, event_id);
        createEventStmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
        createEventStmt.executeUpdate();
        return true;
      }
    } catch (SQLException e) {
      return false;
    }
  }

  /**
   * Remove a user from an event
   *
   * @param pool used for database connection
   * @param user_id the unique representation of a user
   * @param event_id the unique representation of a user
   * @return true if that a user is removed from an event successfully, returns false otherwise
   */
  public static boolean userQuitEvent(DataSource pool, String user_id, long event_id) {
    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format("DELETE FROM %s WHERE (user_id = ?) AND (event_id = ?);", TABLE_NAME);
      try (PreparedStatement deleteEventStmt = conn.prepareStatement(stmt)) {
        deleteEventStmt.setString(1, user_id);
        deleteEventStmt.setLong(2, event_id);
        deleteEventStmt.executeUpdate();
        return true;
      }
    } catch (SQLException e) {
      return false;
    }
  }
}
