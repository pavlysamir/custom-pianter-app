import 'package:flutter/material.dart';

class DrawingPoint {
  int id;
  List<Offset> offsets;
  Color color;
  double width;
  double opacity;

  DrawingPoint(
      {this.id = -1,
      this.offsets = const [],
      this.color = Colors.black,
      this.width = 2,
      this.opacity = 1.0});

  DrawingPoint copyWith({List<Offset>? offsets}) {
    return DrawingPoint(
        id: id,
        color: color,
        width: width,
        offsets: offsets ?? this.offsets,
        opacity: opacity);
  }
}
