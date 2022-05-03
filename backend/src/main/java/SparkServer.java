import static spark.Spark.*;

import DAO.User;
import DTO.DataResponse;
import DTO.OperationResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
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


        get("/hello", (req, res) -> "Hello World");

    // http://localhost:4567/user/:id
    get(
        "/event",
        (request, response) -> {
          String id = request.queryParams("id");
          if (UserController.isUserExist(pool, id)) {
            User user = UserController.getUser(pool, id);
            DataResponse resp = new DataResponse(200, "Success", user);
            return gson.toJson(resp);
          } else {
            return gson.toJson(new OperationResponse(400, "User not exist"));
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