import DAO.Event;
import com.jayway.restassured.RestAssured;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.junit.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import static com.jayway.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;

public class ApiIT {
  static String idToken;
  static String header;

  @BeforeClass
  public static void initializeServer() throws IOException, ParseException {
    SparkServer.main(new String[] {"test"});
    RestAssured.port = 8080;
    RestAssured.baseURI = "http://localhost";
    RestAssured.basePath = "/";
    idToken = getIdToken();
    header = "Bearer " + idToken;
  }

  /*
        ------------------------------- TESTING EVENT RELATED APIs -----------------------------------
   */
  @Test
  public void testGetEventByID() {
    given().when().get("event/id?eventid=1").then().assertThat().body(containsString("test111"));
  }

  @Test
  public void testGetEventsInNextNDays() {
    given().when().get("event/list").then().assertThat().body(containsString("message"));
  }

  @Test
  public void testPostEvent() {
    Event event = new Event();
    event.event_name = "TEST EVENT";
    event.description = "Testing event";
    event.is_public = 1;
    event.is_deleted = 0;
    event.location_name = "CSE2";
    event.latitude = (float) 47.653157358950686;
    event.longitude = (float) -122.30507501538806;
    event.start_time = "2022-06-01 12:00:00";
    event.end_time = "2022-06-02 12:00:00";
    event.max_participants = 20;
    event.curr_num_participants = 0;
    event.address = "3800 E Stevens Way NE, Seattle, WA 98195";
    given()
        .header("Authorization", header)
        .contentType("application/json")
        .body(event)
        .when()
        .post("event")
        .then()
        .assertThat()
        .body(containsString("Success"));
  }

  @Test
  public void testPutEvent() {
    Event event = new Event();
    event.event_id = 2;
    event.event_name = "ACM Fair";
    event.description = "Testing event";
    event.is_public = 1;
    event.is_deleted = 0;
    event.location_name = "CSE2";
    event.latitude = (float) 47.653157358950686;
    event.longitude = (float) -122.30507501538806;
    event.start_time = "2099-06-01 12:00:00";
    event.end_time = "2099-06-02 12:00:00";
    event.max_participants = 20;
    event.photo_id = "";
    event.icon = "";
    event.curr_num_participants = 0;
    event.address = "3800 E Stevens Way NE, Seattle, WA 98195";
    given()
        .header("Authorization", header)
        .contentType("application/json")
        .body(event)
        .when()
        .put("event")
        .then()
        .assertThat()
        .body(containsString("Success"));
  }

  @Test
  public void testDeleteEvent() {
    Event event = new Event();
    event.event_id = 1;
    given()
        .header("Authorization", header)
        .contentType("application/json")
        .body(event)
        .when()
        .delete("event")
        .then()
        .assertThat()
        .body(containsString("403"));
  }

 /*
       ------------------------------- TESTING USER API -----------------------------------
  */

  @Test
  public void testGetUserByID() {
    given()
            .given()
            .header("Authorization", header)
            .when()
            .get("user")
            .then()
            .assertThat()
            .body(containsString("Success"));
  }

  /**
   * Get the id token for header
   *
   * @return the temporary id token
   */
  public static String getIdToken() {
    StringBuffer output = new StringBuffer();

    Process p;
    try {
      p = Runtime.getRuntime().exec("src/integration-test/java/getIdToken.sh");
      p.waitFor();
      BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));

      String line = "";
      while ((line = reader.readLine()) != null) {
        output.append(line + "\n");
      }
      JSONObject jo = (JSONObject) new JSONParser().parse(output.toString());

      return idToken = (String) jo.get("idToken");

    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  @After
  public void cleanUp() {}
}
