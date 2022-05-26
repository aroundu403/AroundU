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
import static org.junit.Assert.*;
import com.google.gson.Gson;

public class EventAPIIT {
  static String idToken;

  @BeforeClass
  public static void initializeServer() throws IOException, ParseException {
    SparkServer.main(new String[] {"test"});
    RestAssured.port = 8080;
    RestAssured.baseURI = "http://localhost";
    RestAssured.basePath = "/event/";

    StringBuffer output = new StringBuffer();

    String command =
        "curl 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBZkbykG8FLdHW2a8oTpfqRIcATXHnrgdI' \\\n"
            + "-H 'Content-Type: application/json' \\\n"
            + "--data-binary '{\"email\":\"aroundu@test.com\",\"password\":\"123456\",\"returnSecureToken\":true}'";
    Process p;
    try {
      p = Runtime.getRuntime().exec(command);
      p.waitFor();
      BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));

      String line = "";
      while ((line = reader.readLine()) != null) {
        output.append(line + "\n");
      }
      System.out.println(output.toString());

    } catch (Exception e) {
      e.printStackTrace();
    }
    JSONObject jo = (JSONObject) new JSONParser().parse(output.toString());

    // getting firstName and lastName
    idToken = (String) jo.get("idToken");
  }

  @Test
  public void testGetEventByID() {
    given().when().get("/id?eventid=1").then().assertThat().body(containsString("test111"));
  }

  @Test
  public void testGetEventsInNextNDays() {
    given().when().get("/list").then().assertThat().body(containsString("400"));
  }

  @After
  public void temp(){
    System.out.println(idToken);
  }
}
