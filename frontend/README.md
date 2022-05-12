# Frontend

This is the AroundU Flutter frontend where users can interact with our product from multiple platforms. </br>
Access the most up-to-date web version of AroundU at [https://aroundu-403.web.app/#/](https://aroundu-403.web.app/#/) </br>
Learn more about our UI design in [Figma](https://www.figma.com/file/L12QAFCSRn0pIq9oDNmzXi/AroundU-(Copy)?node-id=0%3A1)

## Project strucute
- /lib: source code folder
    - /auth：user authorization module
    - /event: event related module
    - main.dart the entry point of Flutter project
    - home_page: home page after user has login.
    - firebase_options.dart: platform depenedent Firebase configuration
- /andriod: Generated Andriod articraft
- /ios: Generated iOS articraft
- /web: Generated web page articraft
- /windows: Generated Windos articraft
- /test: test code for Flutter
- pubspec.yaml: Flutter project configuration file
- firebase.json: Filebase project configuration file 

## Before you start
**> Setting up everything you need for a Flutter project isn't easy. Consider using the deployed version instead of building from source code. Double think before you go into the setup hell**

- Install Flutter and its development dependences. Follow the [offical guide](https://docs.flutter.dev/get-started/install?gclid=Cj0KCQjwmuiTBhDoARIsAPiv6L-IlgpgVr44lmg_KoBgytkVF59rI3wHkyRr18sYWGarML2UWXBlGOsaAhdtEALw_wcB&gclsrc=aw.ds)
- Put the secret API strings into a env file in /frontend. The application will need those secret strings to access dependences. Contact @John to get the secret strings.
- Make sure your GCP accout has access to the arondu-403 project.
- Login your GCP account in your gcloud cli
- install the Vscode Flutter plugin so you have more development support.
- run `flutter pub get` to install all the FLutter dependence
- run `flutter run` to spin up the Flutter proeject.
- Troubleshoot any environment problem. (You are likely going to run into environment problems)

## How to build the system
Build output articraft in a specific platform by:
```
flutter build <platform>
```

## How to run the stystm
Select the debugging environment and run Flutter by:
```
flutter run
```

## How to test the system
Currently, there is no automated test for frontend. As we stated in the testing plan, we will manual test the frontend. Though, Flutter supports test command to test the application.
```
flutter test
```

## How to deploy web version to Firebase Hosting:
Prerequisite:
- Make sure you have the web supported version of Flutter 
- Make sure you install `npm install -g firebase-tools`, login to Firebase by `firebase login`, 
and set up hosting by running `firebase init hosting`
- If you don't have access to Firebase project `aroundu-403`, contact John to give you permission.
```
flutter build web
firebase deploy
```