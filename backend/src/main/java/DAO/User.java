package DAO;

import java.sql.Timestamp;

// Data representation of a user
public class User {

    public String user_id;
    public String register_time;
    public String email;
    public String user_name;
    public String description;

    public User() {
        this.user_id = "";
        this.user_name = "";
        this.email = "";
        this.description = "";
        this.register_time = "2022-01-01 00:00:00";
    }

    public User(String id, String user_name, String email, String description) {
        this.user_id = id;
        this.user_name = user_name;
        this.email = email;
        this.description = description;
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
