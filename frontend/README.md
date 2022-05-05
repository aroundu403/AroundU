# frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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