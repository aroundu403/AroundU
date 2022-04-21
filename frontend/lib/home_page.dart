

import 'package:aroundu/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Home"),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: const Text("Sign out"),
          )
        ],
      ),
    );
  }
}