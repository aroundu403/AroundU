import DAL.UserController;
import DAO.User;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.Assert.*;

public class UserControllerTest {

  // here we get the thing from the environment
  // environment can be set/seen/get from the "configure environment" in the right upper dropbox of
  // each file
  // here we pre set the environment variable to be:
  // DB_USER=root;DB_PASS=kM3CGIGIO0wz7x4u;INSTANCE_CONNECTION_NAME=aroundu-403:us-west1:aroundu-db;DB_NAME=aroundu;DB_TEST_NAME=test
  int cardinality = 0;
  String dbUser = System.getenv("DB_USER");
  String dbPass = System.getenv("DB_PASS");
  String dbName = System.getenv("DB_NAME");
  String dbTestName = System.getenv("DB_TEST_NAME");
  String instanceConnectionName = System.getenv("INSTANCE_CONNECTION_NAME");

  DataSource pool =
      CloudSqlConnectionPool.createConnectionPool(
          dbUser, dbPass, dbTestName, instanceConnectionName);

  /** Initialize the test data in database for each unit test */
  @Before
  public void initializeDatabaseContent() throws SQLException {
    try (Connection conn = pool.getConnection()) {
      String stmt =
          "INSERT INTO users (user_id, user_name, email, description, register_time) VALUES"
              + "(\"test111\", \"TEST1\",\"test1@gmail.com\", \"I am TEST1\", \"2020-01-01 01:01:01\"),"
              + "(\"test222\", \"TEST2\",\"test2@gmail.com\", \"I am TEST2\", \"2020-02-02 02:02:02\")";

      PreparedStatement initStmt = conn.prepareStatement(stmt);
      initStmt.executeUpdate();

      PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(user_id) FROM users;");
      ResultSet countResult = countStmt.executeQuery();
      countResult.next();
      cardinality = countResult.getInt(1);
      countResult.close();
    }
  }

  /** Delete test data from database after each unit test */
  @After
  public void deleteTestDataFromDatabase() throws SQLException {
    try (Connection conn = pool.getConnection()) {
      String stmt =
          "DELETE FROM users WHERE user_id=\"test111\" or user_id=\"test222\" or user_id=\"test333\"";
      PreparedStatement deleteStmt = conn.prepareStatement(stmt);
      deleteStmt.executeUpdate();
    }
  }

  //@Test
  public void testAddUser() throws SQLException {
    UserController.addUser(pool, new User("test333", "Test3", "test3@gmail.com", "I am TEST3"));
    int newCardinality = -1;
    try (Connection conn = pool.getConnection()) {
      PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(user_id) FROM users;");
      ResultSet countResult = countStmt.executeQuery();
      countResult.next();
      newCardinality = countResult.getInt(1);
      countResult.close();
    }
    assertEquals("Cardinality doesn't match!", cardinality + 1, newCardinality);
  }

  /**
   * Test getUser by userID
   *
   * @throws SQLException
   */
  //@Test
  public void testGetUser() throws SQLException {
    User resultUser = UserController.getUser(pool, "test111");
    assertEquals("User_name doesn't match!", "TEST1", resultUser.user_name);
  }

  /**
   * Test updateUserDescription
   *
   * @throws SQLException
   */
  //@Test
  public void testUpdateUserDescription() throws SQLException {
    UserController.updateUserDescription(pool, "test111", "Update Test111");
    String newDescp;
    try (Connection conn = pool.getConnection()) {
      PreparedStatement countStmt =
          conn.prepareStatement("SELECT description FROM users WHERE " + "user_id=\"test111\";");
      ResultSet userResult = countStmt.executeQuery();
      userResult.next();
      newDescp = userResult.getString(1);
      userResult.close();
    }
    assertEquals("Cardinality doesn't match!", "Update Test111", newDescp);
  }

  /**
   * Test isUserExist
   *
   * @throws SQLException
   */
  //@Test
  public void testIsUserExist() throws SQLException {
    assertTrue("Exist!", UserController.isUserExist(pool, "test111"));
    assertFalse("Not Exist!", UserController.isUserExist(pool, "test999"));
  }
}
