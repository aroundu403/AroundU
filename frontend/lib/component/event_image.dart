/// Event Image will display the image of the event given the event id
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  const EventImage({Key? key, required this.eventId, required this.boxFit}) : super(key: key);
  final int eventId;
  final BoxFit boxFit;

  Future<String> _imageDownloadURL(int eventId) async {
    return await FirebaseStorage.instance.ref("event$eventId/image1").getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _imageDownloadURL(eventId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: boxFit
                  ),
                )
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) => 
              Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(value: downloadProgress.progress)
            ))
          );
        } else if (snapshot.hasError) {
          return Image.asset("images/icon.png");
        }
        return const SizedBox();
      }
    );
  }
}