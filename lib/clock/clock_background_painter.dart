import 'dart:math' as math;

import 'package:flutter/material.dart';

class ClockBackgroundPainter extends CustomPainter {
  final Color _borderColor;
  final Color _backgroundColor;
  final Color _minTextColor;
  final Color _hour12TextColor;
  final Color _hour24TextColor;
  final MaterialColor primaryMaterialColor;

  ClockBackgroundPainter({
    required this.primaryMaterialColor,
    Color? borderColor,
    Color? backgroundColor,
    Color? hourPointerColor,
    Color? minPointerColor,
    Color? secPointerColor,
    Color? minTextColor,
    Color? hour12TextColor,
    Color? hour24TextColor,
    Color? timediffPositiveColor,
    Color? timediffNegativeColor,
  })  : _borderColor = borderColor ?? primaryMaterialColor.shade900,
        _backgroundColor = backgroundColor ?? primaryMaterialColor.shade800,
        _minTextColor = minTextColor ?? primaryMaterialColor.shade200,
        _hour12TextColor = hour12TextColor ?? primaryMaterialColor.shade200,
        _hour24TextColor = hour24TextColor ?? primaryMaterialColor.shade200;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Offset center = Offset(centerX, centerY);
    final double radius = math.min(centerX, centerY);

    final fillBrush = Paint()..color = _backgroundColor;
    final outLineBrush = Paint()
      ..color = _borderColor
      ..style = PaintingStyle.fill;
    //final centerDotBrush = Paint()..color = _borderColor;

    double outterBorderCircleRadius = radius * 0.9;
    double backgroundCircleRadius = radius * 0.8;
    double outterBorderWidth =
        outterBorderCircleRadius - backgroundCircleRadius;
    //double centerCircleRadius = radius * 0.05;

    double hour24TextRadius =
        outterBorderCircleRadius - (outterBorderWidth * 4);
    double hour24TextFontSize = radius * 0.06;
    double hour12TextRadius =
        outterBorderCircleRadius - (outterBorderWidth * 2.5);
    double hour12TextFontSize = radius * 0.1;
    double hour12LineWidth = outterBorderWidth * 0.4;
    double minTextRadius = outterBorderCircleRadius - (outterBorderWidth) * 0.5;
    double minTextFontSize = radius * 0.06;
    //double centerTextFontSize = radius * 0.15;

    canvas.drawCircle(center, radius * 0.9, fillBrush);
    //canvas.drawCircle(center, radius * 0.9, outLineBrush);

    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()
            ..addOval(Rect.fromCircle(
                center: center, radius: outterBorderCircleRadius)),
          Path()
            ..addOval(Rect.fromCircle(
                center: center, radius: backgroundCircleRadius - 1))
            ..close(),
        ),
        outLineBrush);

    paint24HourTexts(
      canvas: canvas,
      center: center,
      radius: radius,
      textRadius: hour24TextRadius,
      fontSize: hour24TextFontSize,
    );
    paint12HourInfo(
      canvas: canvas,
      center: center,
      radius: radius,
      textRadius: hour12TextRadius,
      fontSize: hour12TextFontSize,
      outterBorderCircleRadius: outterBorderCircleRadius,
      backgroundCircleRadius: backgroundCircleRadius,
      hour12LineWidth: hour12LineWidth,
    );
    paintMinutes(
        canvas: canvas,
        center: center,
        radius: radius,
        textRadius: minTextRadius,
        fontSize: minTextFontSize,
        minuteTickLength: outterBorderWidth * 0.5);
  }

  void paint12HourInfo(
      {required Canvas canvas,
      required Offset center,
      required double radius,
      required double textRadius,
      required double fontSize,
      required double outterBorderCircleRadius,
      required double backgroundCircleRadius,
      required double hour12LineWidth}) {
    final Paint lineBrush = Paint()
      ..color = _borderColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = hour12LineWidth;

    TextStyle textStyle = TextStyle(
      color: _hour12TextColor,
      fontSize: fontSize,
    );

    double borderThickness = outterBorderCircleRadius - backgroundCircleRadius;

    double outterLineDistance = backgroundCircleRadius;
    double innerLineDistance = backgroundCircleRadius - borderThickness / 2;

    for (double i = 0; i < 360; i += 30) {
      double x1 = center.dx + outterLineDistance * math.sin(i * math.pi / 180);
      double y1 = center.dy + outterLineDistance * -math.cos(i * math.pi / 180);

      double x2 = center.dx + innerLineDistance * math.sin(i * math.pi / 180);
      double y2 = center.dy + innerLineDistance * -math.cos(i * math.pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), lineBrush);

      int minute = i == 0 ? 12 : (i * 12 / 360).floor();
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: minute.toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: 40);

      double hourX1 = center.dx -
          textPainter.width / 2 +
          textRadius * math.sin(i * math.pi / 180);
      double hourY1 = center.dy -
          textPainter.height / 2 +
          textRadius * -math.cos(i * math.pi / 180);

      textPainter.paint(canvas, Offset(hourX1, hourY1));
    }
  }

  void paint24HourTexts({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double textRadius,
    required double fontSize,
  }) {
    TextStyle textStyle = TextStyle(
      color: _hour24TextColor,
      fontSize: fontSize,
    );
    double distanceFromCenter = textRadius;

    for (int i = 0; i < 360; i += 30) {
      int hour = i == 0 ? 12 : (i * 12 / 360).floor();
      hour += 12;

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: hour.toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: 40);

      double x1 = center.dx -
          textPainter.width / 2 +
          distanceFromCenter * math.sin(i * math.pi / 180);
      double y1 = center.dy -
          textPainter.height / 2 +
          distanceFromCenter * -math.cos(i * math.pi / 180);

      textPainter.paint(canvas, Offset(x1, y1));
    }
  }

  void paintMinutes({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double textRadius,
    required double minuteTickLength,
    double fontSize = 10,
  }) {
    TextStyle textStyle = TextStyle(
      color: _minTextColor,
      fontSize: fontSize,
    );

    for (int i = 0; i < 360; i += 6) {
      if (i % 30 == 0) {
        int minute = i == 0 ? 60 : (i * 60 / 360).floor();
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: minute.toString(),
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: minuteTickLength * 2);

        double x1 = center.dx -
            textPainter.width / 2 +
            textRadius * math.sin(i * math.pi / 180);
        double y1 = center.dy -
            textPainter.height / 2 +
            textRadius * -math.cos(i * math.pi / 180);

        textPainter.paint(canvas, Offset(x1, y1));
      } else {
        final Paint lineBrush = Paint()
          //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
          ..color = _backgroundColor
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        var outterLineDistance = textRadius + minuteTickLength / 2;
        var innerLineDistance = textRadius - minuteTickLength / 2;

        double linex1 =
            center.dx + outterLineDistance * math.sin(i * math.pi / 180);
        double liney1 =
            center.dy + outterLineDistance * -math.cos(i * math.pi / 180);

        double linex2 =
            center.dx + innerLineDistance * math.sin(i * math.pi / 180);
        double liney2 =
            center.dy + innerLineDistance * -math.cos(i * math.pi / 180);

        canvas.drawLine(
            Offset(linex1, liney1), Offset(linex2, liney2), lineBrush);
      }
    }
  }

  @override
  bool shouldRepaint(ClockBackgroundPainter oldDelegate) {
    return primaryMaterialColor != oldDelegate.primaryMaterialColor;
  }
}

class PointerProperties {
  final double length;
  final Paint paint;

  PointerProperties({required this.length, required this.paint});
}
