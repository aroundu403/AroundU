// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:aroundu/component/event_input_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {

  testWidgets('shows post event title', (WidgetTester tester) async {

    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: EventInputCardTitle("Test Title"),
        ),
    ));
    expect(find.text("Test Title"), findsOneWidget);
    // load the config file
    // dotenv.testLoad(fileInput: File("./env").readAsStringSync(), mergeWith: Platform.environment);
    //   // initalize firebase with platform sepcific config
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // // Build our app and trigger a frame.
    // await tester.pumpWidget(const AuthGate());
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}

