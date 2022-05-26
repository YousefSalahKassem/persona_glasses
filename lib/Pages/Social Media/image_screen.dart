import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Pages/Social%20Media/social_screen.dart';
import 'package:photo_view/photo_view.dart';


class ImageDetails extends StatelessWidget {
  String image;

  ImageDetails(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PhotoView(
          initialScale: PhotoViewComputedScale.contained * 0.8,
          imageProvider: NetworkImage(image),
        ),
      ),
    );
  }
}