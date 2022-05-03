import javax.sql.DataSource;
import java.sql.*;
import java.sql.Timestamp;
import java.util.*;
import DAO.User;

// This class will perform user related operations, such as inserting a new user,
// getting user data
public class UserController {

    private static final String TABLE_NAME = "users";


    /**
     * Returns a list of all users in the database.
     * @param pool used for database connection
     * @return a list of user object
     * @throws SQLException
     */
    public static ArrayList<User> getUsers(DataSource pool) throws SQLException {
        ArrayList<User> users = new ArrayList<>();
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "SELECT user_name, email, description FROM %s",
                    TABLE_NAME);
            try(PreparedStatement getUsersStmt = conn.prepareStatement(stmt)) {
                ResultSet userResults = getUsersStmt.executeQuery();
                while (userResults.next()) {
                    User user = new User();
                    user.user_name = userResults.getString(1);
                    user.email = userResults.getString(2);
                    user.description = userResults.getString(3);
                    users.add(user);
                }
                userResults.close();
                return users;
            }
        }
    }


    /**
     * Return one user based on given user_id
     * @param pool used for database connection
     * @param user_id unique representation of a user
     * @return a user object or null if this user is not found
     * @throws SQLException
     */
    public static User getUser(DataSource pool, String user_id) throws SQLException {
        User user = null;
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "SELECT user_name, email, description FROM %s WHERE user_id = ?",
                    TABLE_NAME);
            try(PreparedStatement getUserStmt = conn.prepareStatement(stmt)) {
                getUserStmt.setString(1, user_id);
                ResultSet userResults = getUserStmt.executeQuery();
                while (userResults.next()) {
                    user = new User();
                    user.user_name = userResults.getString(1);
                    user.email = userResults.getString(2);
                    user.description = userResults.getString(3);
                }
                userResults.close();
                return user;
            }
        }
    }

    /**
     * Add a user to the users Table based on given information
     * @param pool used for database connection
     * @param user_id unique representation of a user
     * @param user_name user'sname
     * @param email user's email
     * @param description user description
     * @return returns true if insert successfully, returns false otherwise
     */
    public static boolean addUser(DataSource pool, String user_id, String user_name, String email, String description) {
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "INSERT INTO %s (user_id, user_name, email, description, register_time) VALUES (?, ?, ?, ?, ?);",
                    TABLE_NAME);
            try(PreparedStatement addUserStmt = conn.prepareStatement(stmt)) {
                addUserStmt.setString(1, user_id);
                addUserStmt.setString(2, user_name);
                addUserStmt.setString(3, email);
                addUserStmt.setString(4, description);
                addUserStmt.setString(5, String.valueOf(new Timestamp(System.currentTimeMillis())));
                addUserStmt.executeUpdate();
                return true;
            }
        } catch (SQLException e){
            return false;
        }
    }

    /**
     * Update a user's description
     * @param pool used for database connection
     * @param user_id unique representation of a user
     * @param description user description
     * @return returns true if updateed successfully, returns false otherwise
     */
    public static boolean updateUserDescription(DataSource pool, String user_id, String description) {
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "UPDATE %s SET description = ? WHERE user_id = ?;",
                    TABLE_NAME);
            try(PreparedStatement updateDescriptionStmt = conn.prepareStatement(stmt)) {
                updateDescriptionStmt.setString(1, description);
                updateDescriptionStmt.setString(2, user_id);
                updateDescriptionStmt.executeUpdate();
                return true;
            }
        } catch (SQLException e){
            return false;
        }
    }

    /**
     * Check whether the given user is existed
     * @param pool used for database connection
     * @param user_id unique representation of a user
     * @return returns true if this user already exists, returns false otherwise
     */
    public static boolean isUserExist(DataSource pool, String user_id) {
        try (Connection conn = pool.getConnection()) {
            String stmt = String.format(
                    "SELECT user_name FROM %s WHERE user_id = ?;",
                    TABLE_NAME);
            try(PreparedStatement isUserExistStmt = conn.prepareStatement(stmt)) {
                isUserExistStmt.setString(1, user_id);
                ResultSet userResult = isUserExistStmt.executeQuery();
                if (userResult.next()) {
                    userResult.close();
                    return true;
                } else {
                    userResult.close();
                    return false;
                }
            }
        } catch (SQLException e){
            return false;
        }
    }

}
