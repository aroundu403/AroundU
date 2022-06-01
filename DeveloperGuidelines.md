# Developer Guidelines

# Frontend

This is the AroundU Flutter frontend where users can explore events from multiple platforms. </br>
Learn more about our UI design
in [Figma](https://www.figma.com/file/L12QAFCSRn0pIq9oDNmzXi/AroundU-(Copy)?node-id=0%3A1)

## How to install AroundU
Currently, we have built and released the web version of AroundU. 
You can access the most up-to-date web version of AroundU
at [https://aroundu-403.web.app/#/](https://aroundu-403.web.app/#/) </br>
We are planning to support public iOS version in the future. Stay Tuned!

## Project structure /fronted
- /lib: source code folder
    - /auth：user authorization module
    - /event: event related module
    - /json: dart objects that model data transfer entities
    - /component: helpers widgets that are used to build components of a page
    - main.dart: the entry point of Flutter project
    - home_page: home page after user has logged in.
    - firebase_options.dart: platform dependent Firebase configuration
- /android: generated Android articraft
- /ios: generated iOS articraft
- /web: generated web page articraft
- /windows: Generated Windows articraft
- /test: test code folder for Flutter
- pubspec.yaml: Flutter project configuration file
- firebase.json: Firebase project configuration file

## Before you start

**> Setting up everything you need for a Flutter project isn't easy. Consider using the deployed version instead of
building from source code. Double think before you go into the setup hell**

- Install Flutter and its development dependencies. Follow
  the [official guide](https://docs.flutter.dev/get-started/install?gclid=Cj0KCQjwmuiTBhDoARIsAPiv6L-IlgpgVr44lmg_KoBgytkVF59rI3wHkyRr18sYWGarML2UWXBlGOsaAhdtEALw_wcB&gclsrc=aw.ds)
- **Put the secret API strings into a `env` file in `/frontend`. The application will need those secret strings to access
  dependencies. Contact John (wangj616@uw.edu) to get the secret strings.**
- Make sure your GCP account has access to the `aroundu-403` project
- Login your GCP account in your gcloud cli
- Install the Vscode Flutter plugin so you have more development support
- Run `firebase init` to setup additional Firebase support (e.g. emulators and debuggers)
- Run `flutter pub get` to install all the Flutter dependencies
- Run `flutter run` to spin up the Flutter project.
- Troubleshoot any environment problem. (You are likely going to run into environment problems)

## How to build the system

Build output articraft in a specific platform by:

```
flutter build <platform>
```

## Current dependency:
- Flutter 2.18.0 
- Chrome: 101.0.4951.67
- iOS: 15.4
- Google Cloud SDK 374.0.0
- cloud-datastore-emulator 2.1.0
- firebase_auth: ^3.3.14
- mapbox_gl: ^0.15.0


## How to run the system

Select a debugging environment and run Flutter by:
```
flutter run
```
It is earlier to run the application on Chrome since the start-up time is faster. </br>
It is also possible to run the application on iOS devices and simulator. Developers need to have Xcode and a testing iOS device in their hand. The run cycle is much longer when running on iOS. </br>
We recommend developing on web and testing on iOS devices to perform sanity check.

## How to test the system

Currently, there is no automated test for frontend. As we stated in the testing plan, we will manually test the frontend. </br>
Though, Flutter supports test command to test the application:
```
flutter test
```
Widget test can be added by adding test file in the `/test` folder. The test code should look something like this:
```
void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
```
Widget tests will pump a widget to the test environment and validate expected visual outputs. Test will find the expect output with expect statement to make confirm the visual output are presented on certain state.

## How to deploy web version to Firebase Hosting:
Prerequisite:

- Make sure you have the web supported version of Flutter
- Make sure you install `npm install -g firebase-tools`, login to Firebase by `firebase login`, and set up hosting by
  running `firebase init hosting`
- If you don't have access to Firebase project `aroundu-403`, contact John to give you permission.

```
flutter build web
firebase deploy
```


## Develoer Hints:
### CORS error when running local application:
This is the problem with Chrome default CORS policy. To disable this behavior, run use the `flutter_cors` script
```
# to install
dart pub global activate flutter_cors
# to disable
fluttercors --disable
# to enable
fluttercors --enable
```


# Backend

### File structure /backend

- Data Access Object (DAO): model database entities
    1. `Event.java`
        1. Data representation of an Event
    2. `EventParticipants.java`
        1. Data representation of all participants in an Event
    3. `User.java`
        1. Data representation of a User
    4. `UserParticipates.java`
        1. Data representation of all events a User is in
- Data Transfer Object (DTO): model HTTP request and response entities
    1. `DataResponse.java`
        1. Carries data (code, message, data object) between processes
    2. `OperationResponse.java`
        1. Carries operational data (code, message) between processes
- Data Access Layer (DAL): controls data access from database
    1. `EventController.java`
        1. Manages the Event database operations such as insertion, selection or deletion.
    2. `UserController.java`
        1. Manages the User database operations such as insertion, selection or deletion.
    3. `ParticipateController.java`
        1. Manages the Participate database operations such as insertion, selection or deletion.
- Others:
    1. `SparkServer.java`
        1. Manages all APIs, connection to the database and parsing token from firebase.
    2. `CloudSqlConnectionPool.java`
        1. Generates the datasource connection pool according to the authentication info given.
    3. `CloudKmsEnvelopeAead.java`
        1. Initialize an envelope AEAD primitive for data Encryption. Details can be
           found [here](https://github.com/GoogleCloudPlatform/java-docs-samples/tree/main/cloud-sql/mysql/client-side-encryption#encrypting-fields-in-cloud-sql---mysql-with-tink)
           . (We are not doing encryption at currently stages, but we may have it when necessary)

## Developer's Instructions

### Getting Started

- Install Maven and Java 11.
- (for local development only) 
    - Set up [Cloud SQL Auth proxy](https://cloud.google.com/sql/docs/mysql/connect-instance-auth-proxy)
    - [Connecting to Cloud SQL database](https://github.com/GoogleCloudPlatform/java-docs-samples/blob/main/cloud-sql/mysql/servlet/README.md)
  
- Put the environment variables into your bash file. The backend will need those secrets to access external
  dependencies. Contact John (wangj616@uw.edu) to get the secrets.
  - For Windows, put the environment variables in the "Environment Variables" setting.
- Make sure you have access to our Google Cloud Project and have the GOOGLE_APPLICATION_CREDENTIAL on your local machine.
- Run maven command listed below to compile
    - There is no additional step, once the build is successfully, you should be able to spin up the
      SparkServer

### How to spin up the SparkServer

1. Add environment variable such as database password, which should be set up in previous step. Again, contact @John if
   you don't know them
2. run SparkServer (preferably using Intellij 'Run SparkServer.main()' feature)
    1. Once the server is running, Postman is used to test relevant data access and transfer

### How to use Maven
Run the following commands in `/backend`

1. `mvn install`
   Installs the packaged code to the local Maven repository.

2. `mvn complie`
   Compiles the source code, converts the .java files to .class and stores the classes in target/classes folder.

3. `mvn verify -Psurefire`
   Run integration tests under integration-test/java (testing the connection with database requires environment
   variables)

4. `mvn validate`
   Validates if the project structure is correct, checking if all the dependencies have been downloaded and are
   available in the local repository.
5. `mvn package`
   Packages the compiled code in distributable format like JAR.
6. `mvn clean`
   Clean the files and directories generated by Maven during its build

**Our project is configured that it will not run the integration tests during the build process. Running the tests would require to use the command listed above explicitly.**

### How to deploy to GCP cloud engine

Deploy backend code by manually triggering the deployment GitHub Actions. We have automated
the [build](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-java-with-maven) and
[deploy](https://docs.github.com/en/actions/deployment/about-deployments/deploying-with-github-actions) process by
reducing variations and setting up environment variables. Check
out [GitHub Actions](https://github.com/aroundu403/AroundU/actions) and files inside `.github/workflows` from top-level
directory for details.

**Remember to set up the environment variables
in [GitHub Secrets](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-encrypted-secrets-for-your-repository-and-organization-for-codespaces#adding-secrets-for-a-repository)**

### Test APIs using Postman

- Download [Postman](https://www.postman.com)
- make sure you started the SparkServer
- test the APIs as some examples are provided below

#### Examples

Using Postman `GET` with the example request url to get event data with `event_id = 1`

```
http://localhost:8080/event/id?eventid=1
```

Expected result:

```
{
    "code": 200,
    "message": "Success",
    "data": {
        "event_id": 1,
        "event_code": "EVENT1",
        "event_name": "New Student Fair",
        "description": "This is event1.",
        "host_id": "aaa111",
        "isPublic": 1,
        "isDeleted": 0,
        "location_name": "CSE1",
        "latitude": 47.65346,
        "longitude": -122.30597,
        "max_participants": 10,
        "curr_num_participants": 0,
        "photoID": "event1.jpg",
        "icon": "icon1.jpg",
        "address": "185 E Stevens Way NE, Seattle, WA 98195",
        "start_time": "2022-04-01 12:00:00.0",
        "end_time": "2022-04-02 12:00:00.0",
        "created_at": "2022-04-01 12:00:00.0"
    }
}
```

***
Using Postman `POST` with the example request url, and example request body to create a event

**You need to have a valid user token in the request header to test this. Contact @John if you need a user token**

Example request url:

```
http://localhost:8080/event
```

Example request body:

```
{
    "event_code": "EVENT3",
    "event_name": "event3",
    "description": "This is event3.",
    "host_id": "aaa111",
    "is_public":1,
    "is_deleted": 0,
    "location_name": "CSE2",
    "latitude":47.653157358950686, 
    "longitude":-122.30507501538806,
    "start_time": "2022-06-01 12:00:00", 
    "end_time": "2022-06-02 12:00:00",
    "max_participants": 20, 
    "curr_num_participants": 10, 
    "photo_id": "event3.jpg",
    "icon": "icon3.jpg",
    "address": "University of Washington, 3800 E Stevens Way NE, Seattle, WA 98195",
    "created_at": "Apr 1, 2022, 12:00:00 PM"
}
```

Expected result:

```
{
    "code": 200,
    "message": "Success",
    "data": 4           // this can be different
}
```

***
Use `Get` to retrieve data in the new two weeks:

```
http://localhost:8080/event/list
```

Sample result:

```
{
    "code": 200,
    "message": "Success",
    "data": [
        {
            "event_id": 3,
            "event_code": "EVENT3",
            "event_name": "event3",
            "description": "This is event3.",
            "host_id": "aaa111",
            "is_public": 1,
            "is_deleted": 0,
            "location_name": "CSE2",
            "latitude": 47.653156,
            "longitude": -122.30508,
            "max_participants": 20,
            "curr_num_participants": 10,
            "photo_id": "event3.jpg",
            "icon": "icon3.jpg",
            "address": "University of Washington, 3800 E Stevens Way NE, Seattle, WA 98195",
            "start_time": "2022-05-20 12:00:00.0",
            "end_time": "2022-06-02 12:00:00.0",
            "created_at": "2022-05-09 18:19:37.929"
        },
        {
            "event_id": 2,
            "event_code": "EVENT2",
            "event_name": "HFS Feast",
            "description": "This is event2.",
            "host_id": "bbb222",
            "is_public": 1,
            "is_deleted": 0,
            "location_name": "Lander Hall",
            "latitude": 47.655987,
            "longitude": -122.31494,
            "max_participants": 5,
            "curr_num_participants": 4,
            "photo_id": "event2.jpg",
            "icon": "icon2.jpg",
            "address": "1201 NE Campus Pkwy, Seattle, WA 98105",
            "start_time": "2022-05-25 12:00:00.0",
            "end_time": "2022-05-28 12:00:00.0",
            "created_at": "2022-05-01 12:00:00.0"
        }
    ]
}

```

### Adding new tests

Although we mainly used Postman for testing, you can still add integration-test under `src/integration-test/java` to
test out the connection with the database. Such test should be named with the format `*IT.java`. Sample integration testing is `ApiIT.java`.

Notice that these integration tests can only test the interactions between our server and the database. If you want to
test the APIs by simulating the frontend request and checking the backend responses, you should use Postman to test,
detailed instructions above.

