
/// This is a wrapper class that conditionally render auth_page or homepage 
/// based on whether the user has signed in
import 'package:aroundu/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({ Key? key }) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    return LayoutBuilder(
      builder: (context, constraines) {
        return firebaseUser != null ? HomePage() :
        Scaffold(
          body: Row(
                children: [
                  // If the screen is too wide, display a two column view.
                  // Fill the left half with the theme color and display the name of the app
                  Visibility(
                    visible: constraines.maxWidth >= 1200,
                    child: Expanded(
                      child: Container(
                        height: double.infinity,
                        color: Theme.of(context).backgroundColor,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Around U',
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.headline2!.fontSize,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraines.maxWidth >= 1200
                        ? constraines.maxWidth / 2
                        : constraines.maxWidth,
                    child: const AuthGate(),
                  ),
                ],
              )
          );
      });
  }
}