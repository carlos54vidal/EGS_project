import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_sitter/src/atoms/constant_colors.dart';

class ImageInProfile extends StatelessWidget {
  final Uint8List? imageData;
  final String image;

  const ImageInProfile({
    Key? key,
    this.imageData,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: ConstantColors.white),
        image: DecorationImage(
          image: imageData != null
              ? MemoryImage(imageData!) as ImageProvider<Object>
              : AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
