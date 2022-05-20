import com.jayway.restassured.RestAssured;
import org.junit.*;
import java.io.IOException;
import static com.jayway.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;
import static org.junit.Assert.*;

public class EventAPIIT {

  @BeforeClass
  public static void initializeServer() throws IOException {
    SparkServer.main(new String[] {});
    RestAssured.port = 8080;
    RestAssured.baseURI = "http://localhost";
    RestAssured.basePath = "/event/";
  }

  @Test
  public void testGetEventByID() {
    given().when().get("/id?eventid=1").then().assertThat().body(containsString("Success"));
  }

  @Test
  public void testGetEventsInNextNDays() {
    given().when().get("/list").then().assertThat().body(containsString("Success"));
  }


}
