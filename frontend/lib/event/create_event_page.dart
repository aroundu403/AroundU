

import 'package:aroundu/component/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateEeventPage extends StatefulWidget {
  const CreateEeventPage({Key? key}) : super(key: key);

  @override
  State<CreateEeventPage> createState() => _CreateEeventPageState();
}

class _CreateEeventPageState extends State<CreateEeventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(15)),
          // back to home screen bar 
          Row(
            children: [
              const Padding(padding: EdgeInsets.all(5)),
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
          const SizedBox(height: 10),
          // create event page title
          Row(
            children: [
              const Padding(padding: EdgeInsets.all(16)),
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
          const SizedBox(height: 10),
        ]
      ),
    );
  }
}