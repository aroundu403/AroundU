import java.util.ArrayList;

public class FormatResponse {
    public int code;
    public String message;
    public ArrayList<User> userData;
    public ArrayList<Event> eventData;


    public FormatResponse(){
        this.code = 200;
        this.message = "Success";
        this.userData = new ArrayList<>();
        this.eventData = new ArrayList<>();
    }
}
