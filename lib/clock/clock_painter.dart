import 'dart:math' as math;

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime time;
  final DateTime endTime;
  final Color _outterColor;
  final Color _backgroundColor;
  final Color _hourColor;
  final Color _minColor;
  final Color _secColor;

  ClockPainter(
      {required this.time,
      required this.endTime,
      Color? outterColor,
      Color? backgroundColor,
      Color? hourColor,
      Color? minColor,
      Color? secColor})
      : _outterColor = outterColor ?? const Color(0xFF727EF8),
        _backgroundColor = backgroundColor ?? const Color(0xFF444974),
        _hourColor = hourColor ?? Colors.purple.shade900,
        _minColor = minColor ?? Colors.purple.shade500,
        _secColor = secColor ?? Colors.purple.shade200;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Offset center = Offset(centerX, centerY);
    final double radius = math.min(centerX, centerY);

    final fillBrush = Paint()..color = _backgroundColor;
    final outLineBrush = Paint()
      ..color = _outterColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;
    final centerDotBrush = Paint()..color = _outterColor;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outLineBrush);

    paintClockHands(canvas: canvas, center: center, radius: radius);

    canvas.drawCircle(center, 16, centerDotBrush);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      ((time.hour * 30 + time.minute * 0.5) * math.pi / 180) - (math.pi / 2),
      ((endTime.hour * 30 + endTime.minute * 0.5) * math.pi / 180) -
          (math.pi / 2),
      false,
      Paint()
        //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = time.compareTo(endTime) < 0 ? Colors.green : Colors.red
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    paint12HourTexts(canvas: canvas, center: center, radius: radius);
    paint24HourTexts(canvas: canvas, center: center, radius: radius);
    paintHourOutterIndicatorLines(
        canvas: canvas, center: center, radius: radius);
  }

  void paintClockHands({
    required Canvas canvas,
    required Offset center,
    required double radius,
  }) {
    var centerX = center.dx;
    var centerY = center.dy;

    final hourProperties = PointerProperties(
      length: 0.3,
      paint: Paint()
        ..color = _hourColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 15,
    );

    final minProperties = PointerProperties(
      length: 0.4,
      paint: Paint()
        ..strokeCap = StrokeCap.round
        ..color = _minColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    final secProperties = PointerProperties(
      length: 0.6,
      paint: Paint()
        //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = _secColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    final double hourHandAngle = time.hour * 30 +
        time.minute * 0.5 +
        time.second * 0.00833333333 +
        time.millisecond * 0.00833333333 / 1000;
    final double hourHandX = centerX +
        radius *
            hourProperties.length *
            math.sin(hourHandAngle * math.pi / 180);
    final double hourHandY = centerY +
        radius *
            hourProperties.length *
            -math.cos(hourHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourProperties.paint);

    final double minHandAngle = time.minute * 6 + time.second * 0.1;
    final double minHandX = centerX +
        radius * minProperties.length * math.sin(minHandAngle * math.pi / 180);
    final double minHandY = centerY +
        radius * minProperties.length * -math.cos(minHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minProperties.paint);

    final double secHandAngle = time.second * 6 + time.millisecond * 0.006;
    final double secHandX = centerX +
        radius * secProperties.length * math.sin(secHandAngle * math.pi / 180);
    final double secHandY = centerY +
        radius * secProperties.length * -math.cos(secHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secProperties.paint);
  }

  void paintHourOutterIndicatorLines({
    required Canvas canvas,
    required Offset center,
    required double radius,
  }) {
    final Paint lineBrush = Paint()
      //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..color = _outterColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    double outterLineDistance = radius * 0.8;
    double innerLineDistance = radius * 0.7;
    for (double i = 0; i < 360; i += 30) {
      double x1 = center.dx + outterLineDistance * math.sin(i * math.pi / 180);
      double y1 = center.dy + outterLineDistance * -math.cos(i * math.pi / 180);

      double x2 = center.dx + innerLineDistance * math.sin(i * math.pi / 180);
      double y2 = center.dy + innerLineDistance * -math.cos(i * math.pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), lineBrush);
    }
  }

  void paint12HourTexts({
    required Canvas canvas,
    required Offset center,
    required double radius,
  }) {
    TextStyle textStyle = TextStyle(
      color: _secColor,
      fontSize: 30,
    );
    double distanceFromCenter = radius * 0.6;

    List<({int angle, int hour})> hourAngleList=[(hour:12,angle:0),(hour:3,angle:90),(hour:6,angle:180),(hour:9,angle:270)];

    for(({int angle, int hour}) hourAngle in hourAngleList){
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: hourAngle.hour.toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: 40);


      double x1 = center.dx - textPainter.width / 2 + distanceFromCenter * math.sin(hourAngle.angle * math.pi / 180);
      double y1 = center.dy  - textPainter.height / 2 + distanceFromCenter * -math.cos(hourAngle.angle * math.pi / 180);


      textPainter.paint(canvas, Offset(x1, y1));

    }

  }

  void paint24HourTexts({
    required Canvas canvas,
    required Offset center,
    required double radius,
  }) {
    TextStyle textStyle = TextStyle(
      color: _secColor,
      fontSize: 20,
    );
    double distanceFromCenter = radius * 0.4;

    List<({int angle, int hour})> hourAngleList=[(hour:24,angle:0),(hour:6,angle:90),(hour:12,angle:180),(hour:18,angle:270)];

    for(({int angle, int hour}) hourAngle in hourAngleList){
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: hourAngle.hour.toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: 40);


      double x1 = center.dx - textPainter.width / 2 + distanceFromCenter * math.sin(hourAngle.angle * math.pi / 180);
      double y1 = center.dy  - textPainter.height / 2 + distanceFromCenter * -math.cos(hourAngle.angle * math.pi / 180);


      textPainter.paint(canvas, Offset(x1, y1));

    }
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.endTime != endTime;
  }

  double radiansFromDateTime(DateTime time) {
    return 0;
  }
}

class PointerProperties {
  final double length;
  final Paint paint;

  PointerProperties({required this.length, required this.paint});
}
