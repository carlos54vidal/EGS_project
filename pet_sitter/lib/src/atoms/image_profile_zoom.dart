import 'dart:typed_data';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ImageZoom extends StatelessWidget {
  const ImageZoom({
    super.key,
    this.imageData,
    required this.image,
  });

  final Uint8List? imageData;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 180, horizontal: 10),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.symmetric(vertical: 50),
        decoration: BoxDecoration(
          color: Color.fromRGBO(43, 43, 42, 0.7),
          /* border: Border.symmetric(
            vertical:
                BorderSide(width: 15, color: Color.fromRGBO(43, 43, 42, 0.7)),
          ), */
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: imageData != null
                ? MemoryImage(imageData!) as ImageProvider<Object>
                : AssetImage(image),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
