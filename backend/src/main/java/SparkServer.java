import static spark.Spark.*;

import DAO.Event;
import DAO.User;
import DTO.DataResponse;
import DTO.OperationResponse;
import com.google.gson.Gson;
import javax.sql.DataSource;
import java.util.ArrayList;

public class SparkServer {
    public static void main(String[] args) {
        Gson gson = new Gson();

        String dbUser = System.getenv("DB_USER");
        String dbPass = System.getenv("DB_PASS");
        String dbName = System.getenv("DB_NAME");
        String instanceConnectionName =
                System.getenv("INSTANCE_CONNECTION_NAME");
        // String kmsUri = System.getenv("CLOUD_KMS_URI");   // for data encryption
        DataSource pool =
                CloudSqlConnectionPool.createConnectionPool(dbUser, dbPass, dbName, instanceConnectionName);


        // http://localhost:4567/user/aaa111
        get("/user/:id", (request, response) -> {
            String userID = request.params(":id");
            if (UserController.isUserExist(pool, userID)) {
                User user = UserController.getUser(pool, userID);
                DataResponse resp = new DataResponse(200, "Success", user);
                return gson.toJson(resp);
            } else {
                return gson.toJson(new OperationResponse(400, "User not exist"));
            }
        });
        init();

        // http://localhost:4567/event/1
        get("/event/:id", (request, response) -> {
            String eventID = request.params(":id");
            if (EventController.isEventExist(pool, Long.parseLong(eventID))) {
                Event event = EventController.getEventByID(pool, Long.parseLong(eventID));
                DataResponse resp = new DataResponse(200, "Success", event);
                return gson.toJson(resp);
            } else {
                return gson.toJson(new OperationResponse(400, "Event not exist"));
            }
        });
        init();



        // Create a new event
        post("/event", (request, response) ->
        {
            Event body = gson.fromJson(request.body(), Event.class);
            // if start time >= end time, invalid.
            if (body.start_time.compareTo(body.end_time) < 0) {
                long eventID = EventController.createEvent(pool, body);
                DataResponse resp = new DataResponse(200, "Success", eventID);
                return gson.toJson(resp);
            } else {
                return gson.toJson(new OperationResponse(400, "Invalid parameter"));
            }
        });
        init();


        // Update an existed event
        put("/event/:id", (request, response) ->
        {
            String userID = request.params(":id");
            Event body = gson.fromJson(request.body(), Event.class);
            if (!userID.equals(body.host_id)) {
                return gson.toJson(new OperationResponse(403, "No authentication: Only creator of this event can edit"));
            } else if (EventController.isEventExist(pool, body.event_id)) {
                long eventID = EventController.updateEvent(pool, body);
                DataResponse resp = new DataResponse(200, "Success", eventID);
                return gson.toJson(resp);
            } else {
                return gson.toJson(new OperationResponse(400, "Event not exist"));
            }
        });
        init();

//
//        delete("/", (request, response) -> {
//        // Annihilate something
//        });
//
//        options("/", (request, response) -> {
//        // Appease something
//        });
    }
}