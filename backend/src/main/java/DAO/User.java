package DAO;
import com.google.gson.annotations.SerializedName;
import lombok.Data;

import java.sql.Timestamp;
import java.util.Arrays;

@Data
public class User {

    public long id;
    public Timestamp register_time;
    public String email;
    public String user_name;
    public String description;
    // private String password;
    public long[] event_ids;

    public User() {
        this.id = 0;
        this.user_name = "";
        this.email = "";
        this.description = "";
        this.event_ids = null;
        this.register_time = new Timestamp(System.currentTimeMillis());
    }

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

    public void setEmail(String email) {
        this.email = email;
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

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", register_time=" + register_time +
                ", email='" + email + '\'' +
                ", user_name='" + user_name + '\'' +
                ", description='" + description + '\'' +
                ", event_ids=" + Arrays.toString(event_ids) +
                '}';
    }
}
