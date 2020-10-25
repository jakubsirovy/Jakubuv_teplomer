import 'package:flutter/material.dart';

class Wave extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color(0xff2196f3);
    path = Path();
    path.lineTo(0, size.height * 0.46);
    path.cubicTo(0, size.height * 0.46, size.width * 0.04, size.height * 0.61,
        size.width * 0.04, size.height * 0.61);
    path.cubicTo(size.width * 0.08, size.height * 0.76, size.width * 0.17,
        size.height * 1.06, size.width / 4, size.height);
    path.cubicTo(size.width / 3, size.height * 0.91, size.width * 0.42,
        size.height * 0.46, size.width / 2, size.height / 4);
    path.cubicTo(size.width * 0.58, size.height * 0.05, size.width * 0.67,
        size.height * 0.1, size.width * 0.75, size.height / 4);
    path.cubicTo(size.width * 0.83, size.height * 0.4, size.width * 0.92,
        size.height * 0.66, size.width * 0.96, size.height * 0.79);
    path.cubicTo(size.width * 0.96, size.height * 0.79, size.width,
        size.height * 0.91, size.width, size.height * 0.91);
    path.cubicTo(size.width, size.height * 0.91, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width * 0.96, 0, size.width * 0.96, 0);
    path.cubicTo(
        size.width * 0.92, 0, size.width * 0.83, 0, size.width * 0.75, 0);
    path.cubicTo(size.width * 0.67, 0, size.width * 0.58, 0, size.width / 2, 0);
    path.cubicTo(size.width * 0.42, 0, size.width / 3, 0, size.width / 4, 0);
    path.cubicTo(
        size.width * 0.17, 0, size.width * 0.08, 0, size.width * 0.04, 0);
    path.cubicTo(size.width * 0.04, 0, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, size.height * 0.46, 0, size.height * 0.46);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
