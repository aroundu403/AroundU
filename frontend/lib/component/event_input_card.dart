/// This file contains the helper widgets for create event page
/// Redudent code in the create event page is refacored into widgets in this file
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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

// Display leading title, date picker and time picker in one row.
class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key? key, 
    required this.dateController, 
    required this.leadingTitle, 
    required this.timeController, 
    required this.onDateConfirm, 
    required this.onTimeConfirm, 
    required this.dateValidator, 
    required this.timeValidaotor
    }) : super(key: key);

  final String leadingTitle;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function onDateConfirm;
  final Function onTimeConfirm;
  final String? Function(String?) dateValidator;
  final String? Function(String?)  timeValidaotor;

  @override
  Widget build(BuildContext context) {
    var dateInputDecoration = InputDecoration(
      hintText: "Date",
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      )
    );
    
    var timeInputDecoration = InputDecoration(
      hintText: "Time",
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
      )
    );

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              leadingTitle,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // create data picker by using the flutter_date_picker
        Expanded(
          flex: 6,
          child: TextFormField(
            keyboardType: TextInputType.none,
            autofocus: true,
            controller: dateController,
            cursorColor: Theme.of(context).primaryColor,
            decoration: dateInputDecoration,
            onTap: () {
              // pop up a date picker on the bottom of the screen
              DatePicker.showDatePicker(
                context,
                theme: const DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: DateTime(2022, 1, 1),
                maxTime: DateTime(2030, 12, 31), 
                onConfirm: (date) {
                  onDateConfirm(date);
                }, 
                currentTime: dateController.text.isNotEmpty ? DateTime.parse(dateController.text) : DateTime.now(), 
                locale: LocaleType.en
              );
            },
            validator: dateValidator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: TextFormField(
            keyboardType: TextInputType.none,
            autofocus: true,
            controller: timeController,
            cursorColor: Theme.of(context).primaryColor,
            decoration: timeInputDecoration,
            onTap: () {
              DatePicker.showPicker(
                context,
                onConfirm: (date) {
                  onTimeConfirm(date);
                },
                locale: LocaleType.en,
                pickerModel: CustomPicker(currentTime: 
                  timeController.text.isNotEmpty ?
                    DateTime.parse("2000-01-01 " + timeController.text + ":00")
                    :
                    DateTime.now()
                )
              );
            },
            validator: timeValidaotor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}

// Customized time picker with discrete minute options
class CustomPicker extends CommonPickerModel {
  // The interval bewtween two minute options. eg. [0 * interval, 1 * interval, 2 * interval, ...]
  final int interval = 5;
  String? digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    setLeftIndex(this.currentTime.hour);
    setMiddleIndex(this.currentTime.minute.toInt() ~/ interval);
    setRightIndex(0);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60 / interval) {
      return digits((index * interval), 2);
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
            currentLeftIndex(), currentMiddleIndex() * interval, currentRightIndex())
        : DateTime(currentTime.year, currentTime.month, currentTime.day, currentLeftIndex(),
            currentMiddleIndex() * interval, currentRightIndex());
  }

  @override
  List<int> layoutProportions() {
    // hind the third column
    return [100, 100, 0];
  }

}