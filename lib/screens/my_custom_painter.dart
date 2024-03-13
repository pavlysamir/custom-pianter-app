import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:painter_art/models/drawing_area.dart';

class MyCustomPainter extends CustomPainter {
  final List<DrawingArea> points;

  MyCustomPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    //canvas.clipRect(rect);

    if (points.isNotEmpty) {
      for (int x = 0; x < points.length - 1; x++) {
        canvas.drawLine(
          points[x].point,
          points[x + 1].point,
          points[x].areaPaint,
        );
        canvas.drawPoints(
          PointMode.points,
          [points[x].point],
          points[x].areaPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
    // oldDelegate.points != points;
  }
}
