import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:aroundu/auth_service.dart';

import 'firebase_options.dart';
import 'home_page.dart';
import 'sign_in_page.dart';

// whether to use local Firebase emulator
const bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (USE_FIRESTORE_EMULATOR) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

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
        Provider<AuthenticationService> (create: (_) => AuthenticationService(FirebaseAuth.instance),),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null, lazy: false),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// controller for showing which page
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    
    if (firebaseUser != null) {
      return HomePage();
    }
    return SignInPage();
  }
}
