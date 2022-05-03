import com.google.gson.Gson;
import jdk.jshell.spi.ExecutionControl;
import org.apache.commons.lang3.NotImplementedException;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserControllerTest {

    Gson gson = new Gson();

    String dbUser = System.getenv("DB_USER");
    String dbPass = System.getenv("DB_PASS");
    String dbName = System.getenv("DB_NAME");
    String instanceConnectionName =
            System.getenv("INSTANCE_CONNECTION_NAME");
    // String kmsUri = System.getenv("CLOUD_KMS_URI");   // for data encryption
    DataSource pool =
            CloudSqlConnectionPool.createConnectionPool(dbUser, dbPass, dbName, instanceConnectionName);


    /**
     * Initialize the test data in database for each unit test
     */
    @Before
    public void initializeDatabaseContent() throws SQLException {
        try (Connection conn = pool.getConnection()) {
          String stmt = "INSERT INTO users (user_id, user_name, email, description, register_time) VALUES" +
                    "(\"test111\", \"TEST1\",\"test1@gmail.com\", \"I am TEST1\", \"2020-01-01 01:01:01\")," +
                    "(\"test222\", \"TEST2\",\"test2@gmail.com\", \"I am TEST2\", \"2020-02-02 02:02:02\")";

          PreparedStatement initStmt = conn.prepareStatement(stmt);
          initStmt.executeQuery();
        }
    }

    /**
     * Delete test data from database after each unit test
     */
    @After
    public void deleteTestDataFromDatabase() throws  SQLException {
        try (Connection conn = pool.getConnection()) {
            String stmt = "DELETE FROM users WHERE user_id=\"test111\" or user_id=\"test222\"";
            PreparedStatement deleteStmt = conn.prepareStatement(stmt);
            deleteStmt.executeQuery();
        }
    }


    @Test
    public void testAddUser() throws SQLException {
        throw new NotImplementedException();
//        try (Connection conn = pool.getConnection()) {
//            String stmt = "INSERT INTO users (user_id, user_name, email, description, register_time) VALUES" +
//                    "(\"test333\", \"TEST3\",\"test3@gmail.com\", \"I am TEST3\", \"2020-03-03 03:03:03\")";
//            PreparedStatement testAddStmt = conn.prepareStatement(stmt);
//        }
    }


    @Test
    public void testGetUsers() {}


    @Test
    public void testGetUser() {}


    @Test
    public void testTestAddUser() {}

    @Test
    public void testUpdateUserDescription() {}

    @Test
    public void testIsUserExist() {}
}
