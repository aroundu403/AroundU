import javax.sql.DataSource;
import java.sql.*;
import java.sql.Timestamp;
import java.util.*;

// This class will perform user related operations, such as inserting a new user,
// getting user data
public class UserController {

    private static final String TABLE_NAME = "users";
    public User addUser(DataSource pool) {
        return null;
    }

    /**
     * Returns a list of all users in the database
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


}
