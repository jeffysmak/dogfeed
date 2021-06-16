import 'package:flutter/material.dart';
import 'package:image_ink_well/image_ink_well.dart';

class DisplayPicture extends StatelessWidget {
  String src;
  double size;

  DisplayPicture(this.src, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleImageInkWell(
        image: NetworkImage(src),
        onPressed: () {},
        size: size,
      ),
    );
  }
}
