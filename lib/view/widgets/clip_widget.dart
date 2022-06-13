import 'package:flutter/material.dart';

class Clip extends CustomClipper<Path> {
  Clip(this.screenSize);

  Size screenSize;



  @override
  getClip(Size size) {
    print(size);
    var screenHeight = screenSize.height;
    print(screenHeight);
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 7.5, size.width - 1, screenHeight / 3.7),
          // Rect.fromLTWH(1, size.height / 5.8 - 164, size.width - 2, 225),
          const Radius.circular(10)));

    return path;
  }

  @override
  bool shouldReclip(oldClipper) {
    return true;
  }
}
