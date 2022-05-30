/// main.dart is the entry point for a Flutter project
/// It intializes top-level depedencies and defines Firebase Authenication Service will be used by other widgets
/// It also defines the how the top-level widget will be built
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:aroundu/auth/auth_service.dart';
import 'auth/auth_wrapper.dart';
import 'firebase_options.dart';

// whether to use local Firebase emulator
const bool useFirebaseEmulator = false;
const backendAddress = 'aroundu-403.uw.r.appspot.com';

// define app color theme
ThemeData theme = ThemeData(
  primaryColor: const Color.fromARGB(255, 92, 74, 210),
  backgroundColor: const Color.fromARGB(255, 81, 65, 143),
  focusColor: const Color(0xff8DFFF2),
  //highlightColor: const Color(0xffff1fa7),

  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 92, 74, 210)),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load the config file
  await dotenv.load(fileName: "env");

  // initalize firebase with platform sepcific config
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // whether to use emulator for local testing
  if (useFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  // start flutter application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Create providers that provide user login info to children weidgets
    // All the descending conpoment can access user with context.watch<User?>()
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null,
            lazy: false),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        home: const AuthWrapper(),
      ),
    );
  }
}
