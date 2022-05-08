package DAO;

import java.util.ArrayList;
import java.util.List;

public class UserParticipates {
    public List<Long> event_id;
    public String user_id;

    public UserParticipates() {
        event_id = new ArrayList<>();
        user_id = "";
    }
}
