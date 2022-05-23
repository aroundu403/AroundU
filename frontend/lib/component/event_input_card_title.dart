import 'package:flutter/material.dart';

class EventInputCardTitle extends StatelessWidget {
  const EventInputCardTitle(this.title, {
    Key? key,
  }) : super(key: key);
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      )
    );
  }
}