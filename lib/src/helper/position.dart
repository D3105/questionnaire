import 'package:flutter/material.dart';

RelativeRect getPosition(GlobalKey key) {
  final renderBox = key.currentContext.findRenderObject() as RenderBox;
  final width = renderBox.size.width;
  final height = renderBox.size.height;
  final topLeftPoint = renderBox.localToGlobal(Offset.zero);
  final position = RelativeRect.fromLTRB(
    topLeftPoint.dx,
    topLeftPoint.dy,
    topLeftPoint.dx + width,
    topLeftPoint.dy + height,
  );

  return position;
}
