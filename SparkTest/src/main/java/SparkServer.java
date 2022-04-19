import static spark.Spark.*;
import com.google.gson.Gson;

public class SparkServer {
    public static void main(String[] args) {
        Gson gson = new Gson();


        get("/hello", (req, res) -> "Hello World");


        // http://localhost:4567/event?id=1
        get("/event", (request, response) -> {
            int id = Integer.parseInt(request.queryParams("id"));
            if (id == 1) return "event 1";
            else {
                return  "event not exist";
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