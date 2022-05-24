/// This file contains the helper widgets for create event page
/// Redudent code in the create event page is refacored into widgets in this file
import 'package:flutter/material.dart';

/// Wrap the input fields (children) into a card with boarder and showdow
class EventInputCard extends StatelessWidget {
  const EventInputCard({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 120, 117, 117)
                .withOpacity(.2),
            blurRadius: 10.0, // soften the shadow
            offset: const Offset(
              2.0,
              3.0,
            ),
          )
        ],
      ),
      child: Card(
        color: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffAF9BF3), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), 
          child: Column(
            children: children
      ))),
    );
  }
}

/// Display the event input title with the primary color
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