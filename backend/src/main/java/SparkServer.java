import DAO.Event;
import DAO.User;
import DTO.DataResponse;
import DTO.OperationResponse;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.google.gson.Gson;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.FirebaseApp;

import static spark.Spark.*;

public class SparkServer {
  public static void main(String[] args) throws IOException {
    Gson gson = new Gson();

    // Database accessing preparation
    String dbUser = System.getenv("DB_USER");
    String dbPass = System.getenv("DB_PASS");
    String dbName = System.getenv("DB_NAME");
    String instanceConnectionName = System.getenv("INSTANCE_CONNECTION_NAME");
    // String kmsUri = System.getenv("CLOUD_KMS_URI");   // for data encryption
    DataSource pool =
        CloudSqlConnectionPool.createConnectionPool(dbUser, dbPass, dbName, instanceConnectionName);

    //    FirebaseOptions options =
    //        FirebaseOptions.builder()
    //            .setCredentials(GoogleCredentials.getApplicationDefault())
    //            .setProjectId("aroundu-403")
    //            .build();
    //
    //    FirebaseApp.initializeApp(options);

    /*
      --------------------------------------- USER RELATED -----------------------------------------------
    */

    // GET /user
    // Show the user information by id
    // http://localhost:4567/user/aaa111

    get(
        "/user/:id",
        (request, response) -> {
          //          String token = request.headers("Authorization");
          //          FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(token);
          //          String userID = decodedToken.getUid();
          String userID = request.params(":id");
          if (UserController.isUserExist(pool, userID)) {
            User user = UserController.getUser(pool, userID);
            DataResponse resp = new DataResponse(200, "Success", user);
            return gson.toJson(resp);
          } else {
            return gson.toJson(new OperationResponse(400, "User not exist"));
          }
        });

    // POST /user
    // for a user to register with email
    // please use postman to test, dropbox select post
    // need to add request body, please copy from the API doc
    // http://localhost:4567/user/ddd444
    post(
        "/user/:id",
        (request, response) -> {
          String userID = request.params(":id");
          User body = gson.fromJson(request.body(), User.class);
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
    // http://localhost:4567/event/id?eventid=1

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
    // http://localhost:4567/event

    post(
        "/event",
        (request, response) -> {
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

    // PUT /event
    // Update an existed event
    // please use postman to test, dropbox select put
    // need to add request body: please copy from the API doc and make modification
    // http://localhost:4567/event/aaa111

    put(
        "/event/:id",
        (request, response) -> {
          String userID = request.params(":id");
          Event body = gson.fromJson(request.body(), Event.class);
          if (!userID.equals(body.host_id)) {
            return gson.toJson(
                new OperationResponse(
                    403, "No authentication: Only creator of this event can edit"));
          } else if (EventController.isEventExist(pool, body.event_id)) {
            long eventID = EventController.updateEvent(pool, body);
            DataResponse resp = new DataResponse(200, "Success", eventID);
            return gson.toJson(resp);
          } else {
            return gson.toJson(new OperationResponse(400, "Event not exist"));
          }
        });

    // DELETE /event
    // Event creator delete a created event
    // http://localhost:4567/event/guest?eventid=3&userid=aaa111
    delete(
        "/event",
        (request, response) -> {
          String eventID = request.queryParams("eventid");
          String userID = request.queryParams("userid");
          // can only delete if event exists
          if (EventController.isEventExist(pool, Long.parseLong(eventID))) {
            Event event = EventController.getEventByID(pool, Long.parseLong(eventID));
            // can only delete if is the creator
            if (event.host_id.equals(userID)) {
              Timestamp curr = new Timestamp(System.currentTimeMillis());
              // can only delete if the event isn't started
              if (curr.compareTo(Timestamp.valueOf(event.start_time)) < 0) {
                if (EventController.deleteEvent(pool, Long.parseLong(eventID))) {
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
    // show the “created event” list

    /*
      ------------------------------- EVENT PARTICIPANTS RELATED -----------------------------------

    */

    // need to add later:
    // GET /event/guest
    // show the “my event” list

    // POST /event/guest
    // Participate in an event
    // please use postman to test, dropbox select post
    // make sure the event end time is in the future, or you will get error code 403
    // http://localhost:4567/event/guest?eventid=2&userid=aaa111

    post(
        "/event/guest",
        (request, response) -> {
          String eventID = request.queryParams("eventid");
          String userID = request.queryParams("userid");
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
    // make sure the user have participated in this event before testing, or you will get error code
    // 402
    // make sure the event end time is in the future, or you will get error code 403
    // http://localhost:4567/event/guest?eventid=2&userid=aaa111

    delete(
        "/event/guest",
        (request, response) -> {
          String eventID = request.queryParams("eventid");
          String userID = request.queryParams("userid");
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
    // http://localhost:4567/event/list?nday=14  e.g within next 2 weeks
    get(
        "/event/list",
        (request, response) -> {
          String nday = request.queryParams("nday");
          ArrayList<Long> eventIDs =
              EventController.getEventsInNextNDays(pool, Integer.parseInt(nday));
          if (eventIDs.size() > 0) {
            DataResponse resp = new DataResponse(200, "Success", eventIDs);
            return gson.toJson(resp);
          } else {
            return gson.toJson(
                new OperationResponse(400, "No Event in the next " + nday + " days."));
          }
        });

    // GET /event/search
    // Get id of events that satisfy the filter option as a list.

    init();
  }
}
