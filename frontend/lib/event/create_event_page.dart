

import 'dart:convert';

import 'package:aroundu/auth/auth_page.dart';
import 'package:aroundu/component/image_upload.dart';
import 'package:aroundu/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import '../component/address_search.dart';
import '../component/event_input_card_title.dart';
import '../json/place.dart';
import 'package:http/http.dart' as http;

class CreateEeventPage extends StatefulWidget {
  const CreateEeventPage({Key? key}) : super(key: key);

  @override
  State<CreateEeventPage> createState() => _CreateEeventPageState();
}

class _CreateEeventPageState extends State<CreateEeventPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 5, top: 20, bottom: 20)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.chevron_left,
                                size: 36,
                                color: Theme.of(context).backgroundColor,
                              ))),
                      ],
                    ),
                    const Expanded(
                      // A flexible child that will grow to fit the viewport but
                      // still be at least as big as necessary to fit its contents.
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: EventInputs(),
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventInputs extends StatefulWidget {
  const EventInputs({Key? key}) : super(key: key);

  @override
  State<EventInputs> createState() => _EventInputsState();
}

class _EventInputsState extends State<EventInputs> {
  late TextEditingController _titleController;
  late TextEditingController _descriController;
  late TextEditingController _addressController;
  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endDateController;
  late TextEditingController _endTimeController;
  double _maxCapcityValue = 10;
  bool isLoading = false;
  late Place _place;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriController = TextEditingController();
    _addressController = TextEditingController();
    _startDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endDateController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriController.dispose();
    _addressController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }
  
  void _postEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    String token = await user.getIdToken();
    final response = await http.post(
      Uri(
        host: backendAddress,
        path: "event",
      ),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'event_name': _titleController.text,
        'description': _descriController.text,
        'is_public': 1,
        'location_name': _place.name,
        'latitude': _place.location.latitude,
        'longitude': _place.location.longitude,
        'start_time': _startDateController.text + ' ' + _startTimeController.text + ':00',
        'end_time': _endDateController.text + ' ' + _endTimeController.text + ':00',
        'max_participants': _maxCapcityValue,
        'address': _place.address
      }));
    print(response);
  }

  @override
  Widget build(BuildContext context) {  
    var shadowBox = BoxDecoration(
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
    );

    var sliderCard = Container(
      decoration: shadowBox,
      child: Card(
        color: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffAF9BF3), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), 
          child: Column(
            children: [
              const EventInputCardTitle("Event Size"),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Slider(
                      value: _maxCapcityValue,
                      min: 5,
                      max: 20,
                      divisions: 15,
                      activeColor: Theme.of(context).primaryColor,
                      thumbColor: Theme.of(context).primaryColor,
                      inactiveColor: Colors.grey,
                      label: _maxCapcityValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _maxCapcityValue = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '$_maxCapcityValue',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                          background : Paint()
                            ..strokeWidth = 20.0
                            ..color = Theme.of(context).backgroundColor
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.round
                        )),
                    ))]),
          ]
        ))));

    var eventTitle = Container(
      decoration: shadowBox,
      child: Card(
        color: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffAF9BF3), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), 
          child: Column(
            children: [
              const EventInputCardTitle("Title"),
              const SizedBox(height: 15),
              TextFormField(
                controller: _titleController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
                  )
                ),
              ),
            ],
      ))));

    var stateDateTime = Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              "Start:",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: _startDateController,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: "Date",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              )
            ),
            onTap: () {
              DatePicker.showDatePicker(
                context,
                theme: const DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: DateTime(2022, 1, 1),
                maxTime: DateTime(2030, 12, 31), 
                onConfirm: (date) {
                  setState(() {
                    _startDateController.text = '${date.year}-${date.month}-${date.day}';
                  });
                }, 
                currentTime: DateTime.now(), 
                locale: LocaleType.en
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: _startTimeController,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: "Time",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              )
            ),
            onTap: () {
              DatePicker.showTimePicker(
                context,
                onConfirm: (date) {
                  setState(() {
                    _startTimeController.text = sprintf('%02i:%02i', [date.hour, date.minute]);
                  });
                },
                currentTime: DateTime.now(), 
                locale: LocaleType.en,
                showSecondsColumn: false,
              );
            },
          ),
        ),
      ],
    );
    
    var endDateTime = Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              "End: ",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: _endDateController,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: "Date",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              )
            ),
            onTap: () {
              DatePicker.showDatePicker(
                context,
                theme: const DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: DateTime(2022, 1, 1),
                maxTime: DateTime(2030, 12, 31), 
                onConfirm: (date) {
                  setState(() {
                    _endDateController.text = '${date.year}-${date.month}-${date.day}';
                  });
                }, 
                currentTime: DateTime.now(), 
                locale: LocaleType.en
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: _endTimeController,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: "Time",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
              )
            ),
            onTap: () {
              DatePicker.showTimePicker(
                context,
                onConfirm: (date) {
                  setState(() {
                    _endTimeController.text = sprintf('%02i:%02i', [date.hour, date.minute]);
                  });
                },
                currentTime: DateTime.now(), 
                locale: LocaleType.en,
                showSecondsColumn: false,
              );
            },
          ),
        ),
      ],
    );

    var dateAndTile = Container(
      decoration: shadowBox,
      child: Card(
        color: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffAF9BF3), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), 
          child: Column(
            children: [
              const EventInputCardTitle("Data & Time"),
              const SizedBox(height: 15),
              stateDateTime,
              const SizedBox(height: 15),
              endDateTime,
            ],
          )
        )));


    var placeSearch = Container(
      decoration: shadowBox,
      child: Card(
        color: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffAF9BF3), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), 
          child: Column(
            children: [
              const EventInputCardTitle("Location"),
              const SizedBox(height: 15),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _addressController,
                  autofocus: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
                    )
                  ),
                ),
                // use Google Map place autocomplete API to search for places
                suggestionsCallback: (query) async {
                  if (query.isNotEmpty) {
                    return await PlaceApiProvider().fetchSuggestions(query);
                  }
                  return <AddressSuggestion>[];
                },
                itemBuilder: (context, AddressSuggestion suggestion) {
                  return ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(suggestion.description),
                  );
                },
                // use the Google Map place detail API to get detailed place information
                onSuggestionSelected: (AddressSuggestion suggestion) async {
                  Place place = await PlaceApiProvider().getPlaceDetailFromId(suggestion.placeId);
                  setState(() {
                    _addressController.text = suggestion.description;
                    _place = place;
                  });
                },
              ),
            ],
          )
      )));

    var postEventButton = SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _postEvent,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const FractionalOffset(0.3, 0.0),
              colors: [Theme.of(context).primaryColor, Theme.of(context).focusColor]
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.center,
            child: isLoading ? 
              const CircularProgressIndicator.adaptive() : 
              const Text(
                "Post Event", 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                )
              )
          ),
        ),
      ),
    );

    var eventDescription = Container(
      decoration: shadowBox,
      child: Card(
        color: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffAF9BF3), width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), 
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Event Description",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                )
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriController,
                cursorColor: Theme.of(context).primaryColor,
                maxLength: 2500,
                maxLines: 10,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0),
                  )
                )
              ),
            ]
      ))));

    return Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Post Event",
                style: TextStyle(
                    fontFamily: 'Inter',
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 30
              )))
          ],
        ),
        const SizedBox(height: 20),
        ImageUploads(),
        const SizedBox(height: 20),
        eventTitle,
        const SizedBox(height: 20),
        dateAndTile,
        const SizedBox(height: 20),
        placeSearch,
        const SizedBox(height: 20),
        sliderCard,
        const SizedBox(height: 20),
        eventDescription,
        const SizedBox(height: 20),
        postEventButton,
        const SizedBox(height: 20),
      ]
    );
  }
}