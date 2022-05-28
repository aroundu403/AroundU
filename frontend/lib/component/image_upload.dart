
/// A widget that allows users to pick and preview a photo from their photo gallery or camera.
/// Handles getting the image from on-device storage and upload to Firestorage.
/// Note this widget isn't supported in Flutter web
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// The quality of image
const int imageQuality = 25;

class ImageUploads extends StatefulWidget {
  const ImageUploads({Key? key}) : super(key: key);

  @override
  ImageUploadsState createState() => ImageUploadsState();
}

class ImageUploadsState extends State<ImageUploads> {

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: imageQuality);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    } else {
      throw Exception('No image selected.');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: imageQuality);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    } else {
      throw Exception('No image selected.');
    }
  }

  Future uploadFile(int eventId) async {
    if (_photo == null) return;

    try {
      final ref = FirebaseStorage.instance.ref().child('event$eventId/image1');
      await ref.putFile(_photo!);
    } catch (e) {
      throw Exception('file upload error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _photo == null ? 
        GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          // todo need to be replaced with box widget
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: const [6, 6, 6, 6],
            color: Colors.grey,
            strokeWidth: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: SizedBox(
                width: 300,
                height: 200,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.grey[800],
                ),
              ),
            ),
          )
        )
        :
        Image.file(
          _photo!,
          height: 250,
          fit: BoxFit.fitHeight,
        )
      );
  }

  // pop up a modal sheet for user to select which method they would like to pick the image
  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    imgFromGallery();
                    Navigator.of(context).pop();
                  }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
    });
  }
}