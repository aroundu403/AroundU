package DAO;

import lombok.Data;
import java.util.*;
import java.sql.Timestamp;

@Data
public class Participate {
    public List<String> user_id;
    public List<Long> event_id;
    public Timestamp register_time;

    public Participate() {
        user_id = new ArrayList<>();
        event_id = new ArrayList<>();
        register_time = Timestamp.valueOf("");
    }
}
