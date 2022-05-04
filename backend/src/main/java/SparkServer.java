import static spark.Spark.*;

import DAO.Event;
import DAO.User;
import DTO.DataResponse;
import DTO.OperationResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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



    }
}
//    get("/", (request, response) -> {
//        // Show something
//        });
//
//        post("/", (request, response) -> {
//        // Create something
//        });
//
//        put("/", (request, response) -> {
//        // Update something
//        });
//
//        delete("/", (request, response) -> {
//        // Annihilate something
//        });
//
//        options("/", (request, response) -> {
//        // Appease something
//        });