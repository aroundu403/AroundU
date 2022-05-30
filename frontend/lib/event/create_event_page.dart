
/// Create event page allows user to create an event by providing the event infomation such as
/// event title, desription, location, and time.
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:aroundu/component/image_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sprintf/sprintf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../component/address_search.dart';
import '../component/event_input_card.dart';
import '../json/place.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

/// Todo:
///   input validator
///   upload image
/// 
class CreateEeventPage extends StatefulWidget {
  const CreateEeventPage({Key? key}) : super(key: key);

  @override
  State<CreateEeventPage> createState() => _CreateEeventPageState();
}

class _CreateEeventPageState extends State<CreateEeventPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
  // This allows us to identify children in the widget tree
  final _imageUploadState = GlobalKey<ImageUploadsState>();
  final _formKey = GlobalKey<FormState>();
  // Input controllers
  late TextEditingController _titleController;
  late TextEditingController _descriController;
  late TextEditingController _addressController;
  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endDateController;
  late TextEditingController _endTimeController;
  double _maxCapcityValue = 10;
  bool isLoading = false;
  Place? _place;

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
  
  /// Given the inputs from the user, validate the input, and create an event
  /// by invoking the backend create event API.
  void _postEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    String token = await user.getIdToken();
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creating Event')),
      );
      final response = await http.post(
        Uri(
          scheme: "https",
          host: backendAddress,
          path: "/event",
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
          'location_name': _place!.name,
          'latitude': _place!.location.latitude,
          'longitude': _place!.location.longitude,
          'start_time': _startDateController.text + ' ' + _startTimeController.text + ':00',
          'end_time': _endDateController.text + ' ' + _endTimeController.text + ':00',
          'max_participants': _maxCapcityValue,
          'address': _place!.address
      }));

      if (response.statusCode == 200) {
        int eventId = jsonDecode(response.body)["data"];
        await _imageUploadState.currentState!.uploadFile(eventId);
        // return to the home page after image upload
        Navigator.pop(context);
      }
    } else {
      // warm the user about invalid input with short toast.
      Fluttertoast.showToast(
        msg: "Invalid Input",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withAlpha(150),
        timeInSecForIosWeb: 3,
        fontSize: 20.0
      );
    }
  }

  String? digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  @override
  Widget build(BuildContext context) {
    // inpput decoration style for all input boxes
    var eventInputDecoration = InputDecoration(
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

    var placeInputDecoration = InputDecoration(
      suffixIcon: IconButton(
      onPressed: _addressController.clear,
        icon: const Icon(Icons.clear),
      ),
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

    // event title input card
    var eventTitle = EventInputCard(
      children: [
        const EventInputCardTitle("Title"),
        const SizedBox(height: 15),
        TextFormField(
          controller: _titleController,
          cursorColor: Theme.of(context).primaryColor,
          decoration: eventInputDecoration,
          validator: (title) {
            if (title == null || title.isEmpty) {
              return "Please entry a title";
            } else if (title.length > 30) {
              return "Title exceeds 30 characters";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ]
    );

    // start date and time picker
    var stateDateTime = DateTimePicker(
      leadingTitle: "Start",
      dateController: _startDateController, 
      timeController: _startTimeController, 
      onDateConfirm: (date) {
        _startDateController.text = sprintf("%02i-%02i-%02i", [date.year, date.month, date.day]);
      }, 
      onTimeConfirm: (date) {
        _startTimeController.text = sprintf('%02i:%02i', [date.hour, date.minute]).trim();
      },
      dateValidator: (date) {
        if (date == null || date.isEmpty) {
          return "Select date";
        }

        DateTime dateTime = DateTime.parse(date);
        if (dateTime.difference(DateTime.now()).inDays < 0) {
          return "Select future date";
        }
        return null;
      },
      timeValidaotor: (time) {
        if (time == null || time.isEmpty) {
          return "Select time";
        }
        
        if (_startDateController.text.isNotEmpty) {
          DateTime dateTime = DateTime.parse(_startDateController.text + ' ' + time + ":00");
          if (dateTime.isBefore(DateTime.now())) {
            return "Select future time";
          }
        }
        return null;
      },
    );
    
    // end data and time picker
    var endDateTime = DateTimePicker(
      leadingTitle: "End ",
      dateController: _endDateController, 
      timeController: _endTimeController, 
      onDateConfirm: (date) {
        _endDateController.text = sprintf("%02i-%02i-%02i", [date.year, date.month, date.day]);
      }, 
      onTimeConfirm: (date) {
        _endTimeController.text = sprintf('%02i:%02i', [date.hour, date.minute]).trim();
      },
      dateValidator: (date) {
        if (date == null || date.isEmpty) {
          return "Select date";
        }

        DateTime dateTime = DateTime.parse(date);
        if (dateTime.difference(DateTime.now()).inDays < 0) {
          return "Select future date";
        }
        
        if (_startDateController.text.isNotEmpty) {
          DateTime startDate = DateTime.parse(_startDateController.text);
          if (dateTime.difference(startDate).inDays < 0) {
            return "Invalid end date";
          }
        }

        return null;
      },
      timeValidaotor: (time) {
        if (time == null || time.isEmpty) {
          return "Select time";
        }
        DateTime? end;
        if (_endDateController.text.isNotEmpty) {
          end = DateTime.parse(_endDateController.text + ' ' + time + ":00");
          if (end.isBefore(DateTime.now())) {
            return "Select future time";
          }
        }

        if (_startDateController.text.isNotEmpty && _startTimeController.text.isNotEmpty &&
          _endDateController.text.isNotEmpty) {
          DateTime start = DateTime.parse(_startDateController.text + ' ' + _startTimeController.text + ":00");
          if (end!.isBefore(start)) {
            return "Invalid end time";
          }
        }

        return null;
      },
    );

    // start & end data picker
    var dateAndTile = EventInputCard(
      children: [
        const EventInputCardTitle("Data & Time"),
        const SizedBox(height: 15),
        stateDateTime,
        const SizedBox(height: 15),
        endDateTime,
      ],
    );

    // place search that allows user to search a place by utilizing Google Place atuocomplete API
    var placeSearch = EventInputCard(
      children: [
        const EventInputCardTitle("Location"),
        const SizedBox(height: 15),
        TypeAheadFormField(
          validator: (place) {
            if (place == null || place.isEmpty || _place == null) {
              return "Please select a validate event location";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textFieldConfiguration: TextFieldConfiguration(
            controller: _addressController,
            decoration: placeInputDecoration,
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
    );

    var sliderCard = EventInputCard(
      children: [
        const EventInputCardTitle("Event Size"),
        Row(
          children: [
            Expanded(
              flex: 6,
              // Use a discrete selector with from [5, 20]
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
                  _maxCapcityValue.toInt().toString(),
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
  );

    var eventDescription = EventInputCard(
      children: [
        const EventInputCardTitle("Event Description"),
        const SizedBox(height: 15),
        TextFormField(
          controller: _descriController,
          cursorColor: Theme.of(context).primaryColor,
          maxLength: 2500,
          maxLines: 10,
          decoration: eventInputDecoration,
          validator: (description) {
            if (description == null || description.isEmpty) {
              return "Please provide an event description";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        )
      ]
    );

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

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Form(
        key: _formKey,
        child: Column(
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
            !kIsWeb ? ImageUploads(key: _imageUploadState) : const SizedBox(),
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
            const SizedBox(height: 50),
          ]
        ),
      ),
    );
  }
}
