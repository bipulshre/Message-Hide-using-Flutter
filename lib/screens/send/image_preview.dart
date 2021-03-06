import 'package:flutter/material.dart';

/// Image Previewer
///
/// {@category Screens: Send}
class SendScreenImageReview extends StatelessWidget {
  final Image image;
  const SendScreenImageReview(this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          minHeight: 200,
          maxHeight: 400,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(300.0),
          child: this.image,
        ));
  }
}
