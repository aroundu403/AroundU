import java.sql.Timestamp;
import java.util.Arrays;

public class User {
    private final long id;
    private final Timestamp register_time;
    private final String email;
    private String user_name;
    private String description;
    // private String password;
    private long[] event_ids;

    public User(long id, String user_name, String email, String description, long[] event_ids, Timestamp register_time) {
        this.id = id;
        this.user_name = user_name;
        this.email = email;
        this.description = description;
        this.event_ids = event_ids;
        this.register_time = register_time;
    }

    public long getId() {
        return id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getEmail() {
        return email;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long[] getEvent_ids() {
        return event_ids;
    }

    public void setEvent_ids(long[] event_ids) {
        this.event_ids = event_ids;
    }

    public Timestamp getRegister_time() {
        return register_time;
    }

}
