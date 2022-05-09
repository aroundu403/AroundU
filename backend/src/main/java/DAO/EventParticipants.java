package DAO;

import java.util.ArrayList;
import java.util.List;

// Data representation of an event participation
public class EventParticipants {
  public List<String> user_id;
  public Long event_id;

  public EventParticipants() {
    user_id = new ArrayList<>();
    event_id = Long.valueOf(0);
  }
}
