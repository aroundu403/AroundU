# Frontend

This is the AroundU Flutter frontend where users can explore events from multiple platforms. </br>
Learn more about our UI design
in [Figma](https://www.figma.com/file/L12QAFCSRn0pIq9oDNmzXi/AroundU-(Copy)?node-id=0%3A1)

## How to install AroundU
Currently, we have built and released the web version of AroundU. 
You can access the most up-to-date web version of AroundU
at [https://aroundu-403.web.app/#/](https://aroundu-403.web.app/#/) </br>
We are planning to support public iOS version in the future. Stay Tuned!

## Project structure
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
