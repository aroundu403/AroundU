package DAO;
import lombok.Data;

import java.sql.Timestamp;

@Data
public class User {

    public String user_id;
    public Timestamp register_time;
    public String email;
    public String user_name;
    public String description;

    public User() {
        this.user_id = "";
        this.user_name = "";
        this.email = "";
        this.description = "";
        this.register_time = Timestamp.valueOf("2022-01-01 00:00:00");
    }

    public User(String id, String user_name, String email, String description, Timestamp register_time) {
        this.user_id = id;
        this.user_name = user_name;
        this.email = email;
        this.description = description;
        this.register_time = register_time;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + user_id +
                ", register_time=" + register_time +
                ", email='" + email + '\'' +
                ", user_name='" + user_name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
