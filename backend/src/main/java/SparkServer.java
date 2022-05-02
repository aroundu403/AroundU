import static spark.Spark.*;

import DAO.User;
import DTO.DataResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.json.simple.parser.JSONParser;
import javax.sql.DataSource;
import java.util.ArrayList;

public class SparkServer {
    public static void main(String[] args) {
        Gson gson = new Gson();
        JSONParser parser = new JSONParser();

        String dbUser = System.getenv("DB_USER"); // e.g. "root", "mysql"
        String dbPass = System.getenv("DB_PASS"); // e.g. "mysupersecretpassword"
        String dbName = System.getenv("DB_NAME"); // e.g. "votes_db"
        String instanceConnectionName =
                System.getenv("INSTANCE_CONNECTION_NAME"); // e.g. "project-name:region:instance-name"
        String kmsUri = System.getenv("CLOUD_KMS_URI");
        DataSource pool =
                CloudSqlConnectionPool.createConnectionPool(dbUser, dbPass, dbName, instanceConnectionName);


        get("/hello", (req, res) -> "Hello World");


        // http://localhost:4567/event?id=1
        get("/event", (request, response) -> {
            int id = Integer.parseInt(request.queryParams("id"));
            if (id == 1) {
                ArrayList<User> users = UserController.getUsers(pool);
                DataResponse resp = new DataResponse(200, "Success", users);
                return gson.toJson(resp);
            }
            else {
                return "not workings";
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