import DAL.UserController;
import DAO.User;
import com.jayway.restassured.RestAssured;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import javax.sql.DataSource;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.jayway.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;
import static org.junit.Assert.*;

public class UserAPIIT {
  static String idToken;
  static String header;

  @BeforeClass
  public static void initializeServer() throws IOException, ParseException {
    SparkServer.main(new String[] {"test"});
    RestAssured.port = 8080;
    RestAssured.baseURI = "http://localhost";
    RestAssured.basePath = "/user";
    idToken = getIdToken();
    header = "Bearer " + idToken;
  }

  @Test
  public void testGetUserByID() {
    given()
        .given()
        .header("Authorization", header)
        .when()
        .get()
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
}
