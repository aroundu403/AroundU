/// This is the sign-in/register page that peforms user authernication.
/// It contains input fields that ask users to provide email and password.
/// After user clicks the submit button, it will send network requests to Firebase and our backend service
import 'dart:convert';
import 'dart:io';
import 'package:aroundu/main.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef OAuthSignIn = void Function();

final FirebaseAuth _auth = FirebaseAuth.instance;

final url = Uri.parse('https://aroundu-403.uw.r.appspot.com/');

/// Helper class to show a snackbar using the passed context.
class ScaffoldSnackbar {
  // ignore: public_member_api_docs
  ScaffoldSnackbar(this._context);

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  final BuildContext _context;

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

/// The mode of the current auth session, either [AuthMode.login] or [AuthMode.register].
// ignore: public_member_api_docs
enum AuthMode { login, register }

extension on AuthMode {
  String get label => this == AuthMode.login
      ? 'Sign in' : 'Register';
}

/// Entrypoint example for various sign-in flows with Firebase.
class AuthGate extends StatefulWidget {
  // ignore: public_member_api_docs
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // user input controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // widget error message
  String error = '';
  String verificationId = '';

  AuthMode mode = AuthMode.login;

  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  late Map<Buttons, OAuthSignIn> authButtons;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      authButtons = {
        Buttons.Google: _signInWithGoogle,
      };
    } else {
      authButtons = {
        if (!Platform.isMacOS) Buttons.Google: _signInWithGoogle,
      };
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // header
                          Text(
                            mode.label,
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.headline2!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                            )
                          ),
                          const SizedBox(height: 40),
                          // error warming hint
                          Visibility(
                            visible: error.isNotEmpty,
                            child: MaterialBanner(
                              backgroundColor: Theme.of(context).errorColor,
                              content: Text(error),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      error = '';
                                    });
                                  },
                                  child: const Text(
                                    'dismiss',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                              contentTextStyle:
                                  const TextStyle(color: Colors.white),
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // text input boxes and buttons
                          Column(
                            children: [
                              // input boxs
                              // only show the name box in register mode
                              mode == AuthMode.register ?
                               TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value != null && value.isNotEmpty ? null : 'Required',
                              ) : const SizedBox(height: 0),
                              mode == AuthMode.register ? const SizedBox(height: 20) : const SizedBox(height: 0),
                              // email input box
                              TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value != null && value.isNotEmpty ? null : 'Required',
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value != null && value.isNotEmpty ? null : 'Required',
                              ),
                            ],
                            ),
                          const SizedBox(height: 20),
                          // gradient submit button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _emailAndPassword,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: const FractionalOffset(0.3, 0.0),
                                    colors: [Theme.of(context).primaryColor, Theme.of(context).focusColor]
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: isLoading ? 
                                    const CircularProgressIndicator.adaptive() : 
                                    Text(
                                      mode.label, 
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      )
                                    )
                                ),
                              ),
                            ),
                          ),
                          // forget password link
                          TextButton(
                            onPressed: _resetPassword,
                            child: const Text('Forgot password?'),
                          ),
                          //const SizedBox(height: 20),
                          // ...authButtons.keys
                          //     .map(
                          //       (button) => Padding(
                          //         padding:
                          //             const EdgeInsets.symmetric(vertical: 5),
                          //         child: AnimatedSwitcher(
                          //           duration: const Duration(milliseconds: 200),
                          //           child: isLoading
                          //               ? Container(
                          //                   color: Colors.grey[200],
                          //                   height: 50,
                          //                   width: double.infinity,
                          //                 )
                          //               : SizedBox(
                          //                   width: double.infinity,
                          //                   height: 50,
                          //                   child: SignInButton(
                          //                     button,
                          //                     onPressed: authButtons[button]!,
                          //                   ),
                          //                 ),
                          //         ),
                          //       ),
                          //     )
                          //     .toList(),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText1,
                              children: [
                                TextSpan(
                                  text: mode == AuthMode.login
                                      ? "Don't have an account? "
                                      : 'You have an account? ',
                                ),
                                TextSpan(
                                  text: mode == AuthMode.login
                                      ? 'Register now'
                                      : 'Click to login',
                                  style: const TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        mode = mode == AuthMode.login
                                            ? AuthMode.register
                                            : AuthMode.login;
                                      });
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// resetPassword callback function
  /// pop up a AlertDialog to ask for the email to send to.
  Future _resetPassword() async {
    String? email;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Send'),
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email'),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  email = value;
                },
              ),
            ],
          ),
        );
      },
    );

    if (email != null) {
      try {
        await _auth.sendPasswordResetEmail(email: email!);
        ScaffoldSnackbar.of(context).show('Password reset email is sent');
      } catch (e) {
        ScaffoldSnackbar.of(context).show('Error resetting');
      }
    }
  }

  /// Sign-in/Register callback function
  /// In sign-in mode, validate user by sending email and password to the Firebase API
  /// In register mode, create an user account from Firebase, change the user name, 
  /// and sychronize the user information with the backend service.
  Future<void> _emailAndPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      setIsLoading();
      try {
        if (mode == AuthMode.login) {
          await _auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
        } else {
          String name = nameController.text;
          String email = emailController.text;
          final UserCredential credential= await _auth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          // set user name if firebase returned user isn't null
          final User? user = credential.user;
          if (user != null) {
            await user.updateDisplayName(name);
            await _sychronizeUserInfo(user, name, email);
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = '${e.message}';
        });
      } catch (e) {
        setState(() {
          error = '$e';
        });
      } finally {
        setIsLoading();
      }
    }
  }

  // Future<void> _emailAndPassword2() async {
  //   if (formKey.currentState?.validate() ?? false) {
  //     setIsLoading();

  //       if (mode == AuthMode.login) {
  //         final result = await _auth.signInWithEmailAndPassword(
  //           email: emailController.text,
  //           password: passwordController.text,
  //         // ignore: invalid_return_type_for_catch_error
  //         ).catchError((e) => {
  //           setState(() {
  //             error = '$e';
  //           })
  //         });
  //       } else {
  //         _auth.createUserWithEmailAndPassword(
  //           email: emailController.text,
  //           password: passwordController.text,
  //         )
  //         .then((credential) => {
  //           final User? user = credential.user;
  //           if (user != null) {
  //             user.updateDisplayName(nameController.text)
  //           }
  //         })
  //         .then((value) => null);
  //         // set user name if firebase returned user isn't null
  //         final User? user = credential.user;
  //         if (user != null) {
  //           await user.updateDisplayName(nameController.text);
  //           await _sychronizeUserInfo(user);
  //         }
  //       }
  //   }
  // }

  // Call sign-in with Google service to use google credential to sign-in
  Future<void> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
        isLoading = false;
      });
    }
  }
  
  // sychronize user information with our backend database
  Future<void> _sychronizeUserInfo(User user, String name, String email) async {
    String token = await user.getIdToken();
    if (token.isNotEmpty) {
      await http.post(
        Uri(
          scheme: "https",
          host: backendAddress,
          path: "/user",
        ),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "user_id": user.uid,
          "user_name": name,
          "email": email,
        })
      );
    }
  }
}
