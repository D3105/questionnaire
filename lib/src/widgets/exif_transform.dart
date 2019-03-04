import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ExifTransform extends StatelessWidget {
  final Widget child;
  final int exifOrientation;

  const ExifTransform({Key key, this.child, this.exifOrientation})
      : assert(exifOrientation >= 1 && exifOrientation <= 8),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = exifOrientation - 1;
    print(exifOrientation);

    final flipDiagonalBit = 1 << 2; //100
    final rotate180Bit = 1 << 1; //010
    final flipXBit = 1; //001

    final flipDiagonal = flipDiagonalBit & orientation != 0;
    final rotate180 = rotate180Bit & orientation != 0;
    final flipX = flipXBit & orientation != 0;

    var transform = Matrix4.identity();

    if (flipDiagonal) {
      transform.rotateZ(-pi / 2);
      transform.scale(-1.0, 1.0, 1.0);
    }
    if (rotate180) transform.rotateZ(pi);
    if (flipX) transform.scale(-1.0, 1.0, 1.0);

    return Transform(
      alignment: FractionalOffset.center,
      transform: transform,
      child: child,
    );
  }
}
