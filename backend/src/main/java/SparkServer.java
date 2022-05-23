import DAL.EventController;
import DAL.ParticipateController;
import DAL.UserController;
import DAO.Event;
import DAO.User;
import DTO.DataResponse;
import DTO.OperationResponse;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.google.gson.Gson;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.FirebaseApp;
import lombok.extern.slf4j.Slf4j;

import static spark.Spark.*;
/**
 * This class manages all APIs, connection to the database and parsing token from firebase.
 *
 * @author Wenxin Zhang, Wei Wu
 */
@Slf4j
public class SparkServer {
  /**
   * This is the main method of the SparkServer class. Make sure to connect to the database before
   * running.
   *
   * @param args any excessive arguments
   * @throws IOException
   */
  public static void main(String[] args) throws IOException {
    Gson gson = new Gson();
    log.info("Starting server...");

    port(Integer.valueOf(System.getenv().getOrDefault("PORT", "8080")));
    // Database accessing preparation
    String dbUser = System.getenv("DB_USER");
    String dbPass = System.getenv("DB_PASS");
    String dbName = System.getenv("DB_NAME");
    if (args.length != 0 && args[0].equals("test")) {
      dbName = System.getenv("DB_TEST_NAME");
    }
    String instanceConnectionName = System.getenv("INSTANCE_CONNECTION_NAME");

    // String kmsUri = System.getenv("CLOUD_KMS_URI");   // for data encryption
    DataSource pool =
        CloudSqlConnectionPool.createConnectionPool(dbUser, dbPass, dbName, instanceConnectionName);

    FirebaseOptions options =
        FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.getApplicationDefault())
            .setProjectId("aroundu-403")
            .build();
    FirebaseApp defaultApp = FirebaseApp.initializeApp(options);

    // Server side cors setting
    options(
        "/*",
        (request, response) -> {
          String accessControlRequestHeaders = request.headers("Access-Control-Request-Headers");
          if (accessControlRequestHeaders != null) {
            response.header("Access-Control-Allow-Headers", accessControlRequestHeaders);
          }
          String accessControlRequestMethod = request.headers("Access-Control-Request-Method");
          if (accessControlRequestMethod != null) {
            response.header("Access-Control-Allow-Methods", accessControlRequestMethod);
          }
          return "OK";
        });
    before((request, response) -> response.header("Access-Control-Allow-Origin", "*"));

    /*
      --------------------------------------- USER RELATED -----------------------------------------------
    */

    // GET /user
    // Show the user information by id (we get id automatically from header)
    // http://localhost:8080/user

    get(
        "/user",
        (request, response) -> {
          String userID = getUserID(request.headers("Authorization"), defaultApp);
          if (UserController.isUserExist(pool, userID)) {
            User user = UserController.getUser(pool, userID);
            DataResponse resp = new DataResponse(200, "Success", user);
            return gson.toJson(resp);
          } else {
            // return gson.toJson(new OperationResponse(400, "User not exist"));
            return gson.toJson(new DataResponse(400, "User not exist", userID));
          }
        });

    // POST /user
    // for a user to register with email
    // please use postman to test, dropbox select post
    // need to add request body, please copy from the API doc
    // http://localhost:8080/user
    post(
        "/user",
        (request, response) -> {
          String userID = getUserID(request.headers("Authorization"), defaultApp);
          User body = gson.fromJson(request.body(), User.class);
          body.user_id = userID;
          if (!UserController.isUserExist(pool, userID)) {
            if (UserController.addUser(pool, body)) {
              DataResponse resp = new DataResponse(200, "Success", userID);
              return gson.toJson(resp);
            } else {
              return gson.toJson(new OperationResponse(500, "SQL server error"));
            }
          } else {
            return gson.toJson(new OperationResponse(403, "Email has been registered"));
          }
        });

    /*
       ------------------------------- EVENT / EVENT CREATORS RELATED -----------------------------------
    */

    // GET /event
    // User check an event.
    // http://localhost:8080/event/id?eventid=1

    get(
        "/event/id",
        (request, response) -> {
          String eventID = request.queryParams("eventid");
          if (EventController.isEventExist(pool, Long.parseLong(eventID))) {
            Event event = EventController.getEventByID(pool, Long.parseLong(eventID));
            DataResponse resp = new DataResponse(200, "Success", event);
            return gson.toJson(resp);
          } else {
            return gson.toJson(new OperationResponse(400, "Event not exist"));
          }
        });

    // POST /event
    // Create a new event
    // please use postman to test, dropbox select post
    // need to add request body: please copy from the API doc
    // http://localhost:8080/event

    post(
        "/event",
        (request, response) -> {
          String userID = getUserID(request.headers("Authorization"), defaultApp);
          Event body = gson.fromJson(request.body(), Event.class);
          // if start time >= end time, invalid.
          if (body.start_time.compareTo(body.end_time) < 0) {
            body.host_id = userID;
            long eventID = EventController.createEvent(pool, body);
            DataResponse resp = new DataResponse(200, "Success", eventID);
            return gson.toJson(resp);
          } else {
            return gson.toJson(new OperationResponse(400, "Invalid parameter"));
          }
        });

    // PUT /event
    // Update an existed event
    // please use postman to test, dropbox select put
    // need to add request body: please copy from the API doc and make modification
    // http://localhost:8080/event

    put(
        "/event",
        (request, response) -> {
          String userID = getUserID(request.headers("Authorization"), defaultApp);
          Event body = gson.fromJson(request.body(), Event.class);
          long eventID = body.event_id;
          if (EventController.isEventExist(pool, eventID)) {
            String hostID = EventController.getEventByID(pool, eventID).host_id;
            // comparison: the user id extracted from header must be the same
            // as the host id of this event in database
            if (!userID.equals(hostID)) {
              return gson.toJson(
                  new OperationResponse(
                      403, "No authentication: Only creator of this event can edit"));
            } else {
              eventID = EventController.updateEvent(pool, body);
              DataResponse resp = new DataResponse(200, "Success", eventID);
              return gson.toJson(resp);
            }
          } else {
            return gson.toJson(new OperationResponse(400, "Event not exist"));
          }
        });

    // DELETE /event
    // Event creator delete a created event
    // need to provide event id in request body
    // http://localhost:8080/event
    delete(
        "/event",
        (request, response) -> {
          long eventID = gson.fromJson(request.body(), Event.class).event_id;
          String userID = getUserID(request.headers("Authorization"), defaultApp);
          // can only delete if event exists
          if (EventController.isEventExist(pool, eventID)) {
            Event event = EventController.getEventByID(pool, eventID);
            // can only delete if is the creator
            if (event.host_id.equals(userID)) {
              Timestamp curr = new Timestamp(System.currentTimeMillis());
              // can only delete if the event isn't started
              if (curr.compareTo(Timestamp.valueOf(event.start_time)) < 0) {
                if (EventController.deleteEvent(pool, eventID)) {
                  DataResponse resp = new DataResponse(200, "Success", null);
                  event.deleted_at = curr.toString();
                  EventController.updateEvent(pool, event);
                  return gson.toJson(resp);
                } else {
                  return gson.toJson(new OperationResponse(500, "SQL server error."));
                }
              } else {
                return gson.toJson(new OperationResponse(402, "The event is started."));
              }
            } else {
              return gson.toJson(
                  new OperationResponse(
                      403, "No authentication: Only creator of this event can delete"));
            }
          } else {
            return gson.toJson(new OperationResponse(400, "Event not exist"));
          }
        });

    // need to add later:
    // VIEW /event
    // show the "created event" list

    /*
      ------------------------------- EVENT PARTICIPANTS RELATED -----------------------------------

    */

    // need to add later:
    // GET /event/guest
    // show the "my event" list

    // POST /event/guest
    // Participate in an event
    // please use postman to test, dropbox select post
    // need to provide event id in request body
    // make sure the event end time is in the future, or you will get error code 403
    // http://localhost:8080/event/guest

    post(
        "/event/guest",
        (request, response) -> {
          String eventID = gson.fromJson(request.body(), String.class);
          String userID = getUserID(request.headers("Authorization"), defaultApp);
          if (EventController.isEventExist(pool, Long.parseLong(eventID))) {
            Event event = EventController.getEventByID(pool, Long.parseLong(eventID));
            // can only participate if event not filled
            if (event.max_participants >= event.curr_num_participants + 1) {
              Timestamp curr = new Timestamp(System.currentTimeMillis());
              // can only participate if the event isn't ended
              if (curr.compareTo(Timestamp.valueOf(event.end_time)) < 0) {
                if (ParticipateController.userParticipateEvent(
                    pool, userID, Long.parseLong(eventID))) {
                  DataResponse resp = new DataResponse(200, "Success", eventID);
                  event.curr_num_participants += 1;
                  EventController.updateEvent(pool, event);
                  return gson.toJson(resp);
                } else {
                  return gson.toJson(new OperationResponse(500, "SQL server error."));
                }
              } else {
                return gson.toJson(new OperationResponse(403, "The event is ended."));
              }
            } else {
              return gson.toJson(new OperationResponse(402, "The event is filled."));
            }
          } else {
            return gson.toJson(new OperationResponse(400, "Event not exist"));
          }
        });

    // DELETE /event/guest
    // Quit an participated event
    // please use postman to test, dropbox select delete
    // need to provide event id in request body
    // make sure the user have participated in this event before testing, or you will get error code
    // 402
    // make sure the event end time is in the future, or you will get error code 403
    // http://localhost:8080/event/guest

    delete(
        "/event/guest",
        (request, response) -> {
          String eventID = gson.fromJson(request.body(), String.class);
          String userID = getUserID(request.headers("Authorization"), defaultApp);
          // can only quit if event exists
          if (EventController.isEventExist(pool, Long.parseLong(eventID))) {
            Event event = EventController.getEventByID(pool, Long.parseLong(eventID));
            // check if event have participants before searching it in participate table to avoid
            // errors
            if (event.curr_num_participants > 0
                && ParticipateController.getEventsByUser(pool, userID)
                    .contains(Long.parseLong(eventID))) {
              Timestamp curr = new Timestamp(System.currentTimeMillis());
              // can only quit if the event isn't ended
              if (curr.compareTo(Timestamp.valueOf(event.end_time)) < 0) {
                if (ParticipateController.userQuitEvent(pool, userID, Long.parseLong(eventID))) {
                  DataResponse resp = new DataResponse(200, "Success", eventID);
                  event.curr_num_participants -= 1;
                  EventController.updateEvent(pool, event);
                  return gson.toJson(resp);
                } else {
                  return gson.toJson(new OperationResponse(500, "SQL server error."));
                }
              } else {
                return gson.toJson(new OperationResponse(403, "The event is ended."));
              }
            } else {
              return gson.toJson(new OperationResponse(402, "You are not in this event."));
            }
          } else {
            return gson.toJson(new OperationResponse(400, "Event not exist"));
          }
        });

    /*
      ------------------------------- EVENT LISTS/SEARCHING RELATED -----------------------------------
    */

    // GET /event/list
    // Get id of events that are within n days as a list.
    // http://localhost:8080/event/list  e.g within next 2 weeks
    get(
        "/event/list",
        (request, response) -> {
          // String nday = request.queryParams("nday");
          ArrayList<Long> eventIDs = EventController.getEventsInNextNDays(pool, 14);
          ArrayList<Event> result_event = new ArrayList<>();
          if (eventIDs.size() > 0) {
            for (long curr : eventIDs) {
              Event event = EventController.getEventByID(pool, curr);
              event.participant_ids = ParticipateController.getUsersByEvent(pool, curr);
              result_event.add(event);
            }
            DataResponse resp = new DataResponse(200, "Success", result_event);
            return gson.toJson(resp);
          } else {
            return gson.toJson(new OperationResponse(400, "No Event in the next " + 14 + " days."));
          }
        });

    // GET /event/search
    // Get id of events that satisfy the filter option as a list.

    init();
  }

  /**
   * Decodes and returns a user id through FirebaseAuth
   *
   * @param token Bearer token from request.header
   * @param defaultApp FirebaseApp
   * @return a decoded userID
   * @throws FirebaseAuthException
   */
  public static String getUserID(String token, FirebaseApp defaultApp)
      throws FirebaseAuthException {
    token = token.split(" ")[1];
    FirebaseToken decodedToken = FirebaseAuth.getInstance(defaultApp).verifyIdToken(token);
    return decodedToken.getUid();
  }

  //  /** Stop the server. */
  //  public static void stopServer() {
  //    System.exit(0);
  //  }
}
