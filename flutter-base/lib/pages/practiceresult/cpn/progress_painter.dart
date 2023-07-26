import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleProgressPainter extends CustomPainter {
  final double progress;

  CircleProgressPainter(this.progress);

  Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 16
    ..strokeCap = StrokeCap.round;

  Gradient gradient = LinearGradient(colors: [
    Color(0xFF62B0FF),
    Color(0xFF28D8A0),
  ]);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width, size.height) / 2;

    var rect = Rect.fromLTWH(0, 0, radius * 2, radius * 2);

    _paint.shader = gradient.createShader(rect);

    canvas.drawArc(rect, pi / 2, pi * 2 * progress, false, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LineProgressPainter extends CustomPainter {
  final double progress;
  final bool isGradient;
  final Color? colorValue;

  LineProgressPainter(this.progress, {this.colorValue, this.isGradient = false});

  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

  Gradient _gradient = LinearGradient(colors: [Color(0xFF00B88F), Color(0xFF29D9A0)]);

  @override
  void paint(Canvas canvas, Size size) {
    var rRect = RRect.fromLTRBR(0, 0, size.width * progress, size.height, Radius.circular(4.0));
    _paint.color = colorValue!;
    if (isGradient) {
      // var rect = Rect.fromLTRB(0, 0, size.width * progress, size.height);
      // todo _gradient.createShader(rect);只能设置Rect，所以暂时不能实现渐变效果
      // _paint.shader = _gradient.createShader(rect);
      // canvas.drawRRect(rect, _paint);
      // canvas.drawRect(rect, _paint);
      canvas.drawRRect(rRect, _paint);
    } else {
      canvas.drawRRect(rRect, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
