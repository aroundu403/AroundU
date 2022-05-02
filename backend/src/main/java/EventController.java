// This class will control the event modules with database

import DAO.Event;

import javax.sql.DataSource;
import java.util.*;

public class EventController {

    private final String TABLE_NAME = "events";

    public static Event createNewEvent(DataSource pool, String code, String title, String description, String host,
                                       List<String> tags) {

        return null;
    }
}
