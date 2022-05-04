// This class will control the participation modules with database
import DAO.Event;
import DAO.User;
import org.apache.commons.lang3.NotImplementedException;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

public class ParticipateController {

    /**
     * Returns a list of users participating that event
     * @param pool used for database connection
     * @param event_id the unique representation of an event
     * @return a list of users
     */
    public static ArrayList<User> getUsersByEvent (DataSource pool, long event_id) {
        throw new NotImplementedException();
    }

    /**
     * Returns a list of events that a user is participating
     * @param pool used for database connection
     * @param user_id the unique representation of a user
     * @return a list of events
     */
    public static ArrayList<Event> getEventsByUser (DataSource pool, long user_id) {
        throw new NotImplementedException();
    }

    /**
     * Returns the current number of users participating that event
     * @param pool used for database connection
     * @param event_id the unique representation of a user
     * @return the current number of users in that event
     */
    public static int countParticipants (DataSource pool, long event_id) {
        throw new NotImplementedException();
    }

}
