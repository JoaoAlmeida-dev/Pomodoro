import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pomodoro/clock/models/alarm_data.dart';

class ClockPainter extends CustomPainter {
  final DateTime currentTime;
  final AlarmData? alarmData;
  final Color _borderColor;
  final Color _backgroundColor;
  final Color _hourPointerColor;
  final Color _minPointerColor;
  final Color _secPointerColor;
  final Color _minTextColor;
  final Color _hour12TextColor;
  final Color _hour24TextColor;
  final Color _timediffPositiveColor;
  final Color _timediffNegativeColor;
  final MaterialColor primaryMaterialColor;

  ClockPainter({
    required this.currentTime,
    required this.primaryMaterialColor,
    this.alarmData,

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
  })  :
        _borderColor = borderColor ?? primaryMaterialColor.shade900,
        _backgroundColor = backgroundColor ?? primaryMaterialColor.shade800,
        _hourPointerColor = hourPointerColor ?? primaryMaterialColor.shade700,
        _minPointerColor = minPointerColor ?? primaryMaterialColor.shade500,
        _secPointerColor = secPointerColor ?? primaryMaterialColor.shade200,
        _minTextColor = minTextColor ?? primaryMaterialColor.shade200,
        _hour12TextColor = hour12TextColor ?? primaryMaterialColor.shade200,
        _hour24TextColor = hour24TextColor ?? primaryMaterialColor.shade200,
        _timediffPositiveColor = timediffPositiveColor ?? primaryMaterialColor.shade200,
        _timediffNegativeColor = timediffNegativeColor ?? primaryMaterialColor.shade800;

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
    final centerDotBrush = Paint()..color = _borderColor;

    double outterBorderCircleRadius = radius * 0.99;
    double backgroundCircleRadius = radius * 0.9;
    double outterBorderWidth =
        outterBorderCircleRadius - backgroundCircleRadius;
    double centerCircleRadius = radius * 0.05;

    double hour24TextRadius =
        outterBorderCircleRadius - (outterBorderWidth * 4);
    double hour24TextFontSize = radius * 0.06;
    double hour12TextRadius =
        outterBorderCircleRadius - (outterBorderWidth * 2.5);
    double hour12TextFontSize = radius * 0.1;
    double hour12LineWidth = outterBorderWidth * 0.4;
    double minTextRadius = outterBorderCircleRadius - (outterBorderWidth) * 0.5;
    double minTextFontSize = radius * 0.06;

    final hourProperties = PointerProperties(
      length: backgroundCircleRadius * 0.3,
      paint: Paint()
        ..color = _hourPointerColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = radius * 0.05,
    );

    final minProperties = PointerProperties(
      length: backgroundCircleRadius * 0.5,
      paint: Paint()
        ..strokeCap = StrokeCap.round
        ..color = _minPointerColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.03,
    );

    final secProperties = PointerProperties(
      length: backgroundCircleRadius * 0.8,
      paint: Paint()
        //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = _secPointerColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.01,
    );

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

    //paint12HourTexts(canvas: canvas, center: center, radius: radius);
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

    paintClockHands(
      canvas: canvas,
      center: center,
      radius: radius,
      hourProperties: hourProperties,
      minProperties: minProperties,
      secProperties: secProperties,
    );
    if (alarmData != null) {
      paintTimeDifference(
        canvas: canvas,
        center: center,
        radius: radius,
        outterBorderCircleRadius: outterBorderCircleRadius,
        centerCircleRadius: centerCircleRadius,
        outterBorderWidth: outterBorderWidth,
        alarmData: alarmData!,
      );
    }

    canvas.drawPath(
      Path()
        ..addOval(Rect.fromCircle(center: center, radius: centerCircleRadius))
        ..close(),
      centerDotBrush,
    );
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
      //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
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

  void paintClockHands({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required PointerProperties hourProperties,
    required PointerProperties minProperties,
    required PointerProperties secProperties,
  }) {
    var centerX = center.dx;
    var centerY = center.dy;

    final double hourHandAngle = currentTime.hour * 30 +
        currentTime.minute * 0.5 +
        currentTime.second * 0.00833333333 +
        currentTime.millisecond * 0.00833333333 / 1000;
    final double hourHandX = centerX +
        hourProperties.length * math.sin(hourHandAngle * math.pi / 180);
    final double hourHandY = centerY +
        hourProperties.length * -math.cos(hourHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourProperties.paint);

    final double minHandAngle = currentTime.minute * 6 + currentTime.second * 0.1;
    final double minHandX =
        centerX + minProperties.length * math.sin(minHandAngle * math.pi / 180);
    final double minHandY = centerY +
        minProperties.length * -math.cos(minHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minProperties.paint);

    final double secHandAngle = currentTime.second * 6 + currentTime.millisecond * 0.006;
    final double secHandX =
        centerX + secProperties.length * math.sin(secHandAngle * math.pi / 180);
    final double secHandY = centerY +
        secProperties.length * -math.cos(secHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secProperties.paint);
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

  void paintTimeDifference({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double outterBorderCircleRadius,
    required double outterBorderWidth,
    required double centerCircleRadius,
    required AlarmData alarmData,
  }) {
    DateTime endTime = alarmData.endTime;
    DateTime startTime = alarmData.startTime;

    Duration timeDifference = endTime.difference(startTime);
    final double outterArcLength = outterBorderWidth * 0.5;
    final double innerArcDistance = centerCircleRadius;
    final double outterArcDistance = outterBorderCircleRadius;

    final Paint arcPaint = Paint()
      ..color = !timeDifference.isNegative
          ? _timediffPositiveColor
          : _timediffNegativeColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = outterArcLength;
    final Paint arcPaintBackground = Paint()
      ..color = !timeDifference.isNegative
          ? _timediffPositiveColor
          : _timediffNegativeColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = outterArcLength;
    arcPaintBackground.color = arcPaintBackground.color.withOpacity(0.4);
    final Paint innerArcPaint = Paint()
      ..color = !timeDifference.isNegative
          ? _timediffPositiveColor
          : _timediffNegativeColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = outterArcLength;

    var angleTime = 0;
    var angleEndTime = alarmData.currentPercentage(currentTime) * -360/100;

    // var hoursDifference = timeDifference.inHours;
    // var minutesDifference =
    //     timeDifference.inMinutes - timeDifference.inHours * 60;
    // var secondsDifference =
    //     timeDifference.inSeconds - timeDifference.inMinutes * 60;
    // var angleEndTime = minutesDifference * 6 +
    //     secondsDifference * 0.1; //+  milliSecondsDifference * 0.0001;
    //
    // if (hoursDifference > 0) {
    //   canvas.drawArc(
    //     Rect.fromCircle(center: center, radius: outterArcDistance),
    //     (0 * math.pi / 180),
    //     (360 * math.pi / 180),
    //     false,
    //     arcPaintBackground,
    //   );
    //   canvas.drawArc(
    //     Rect.fromCircle(center: center, radius: innerArcDistance),
    //     (0 * math.pi / 180),
    //     (360 * math.pi / 180),
    //     false,
    //     arcPaintBackground,
    //   );
    // }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outterArcDistance),
      ((angleTime - 90) * math.pi / 180),
      ((angleEndTime) * math.pi / 180),
      false,
      arcPaint,
    );
    final double outterArcPointerStartX =
        center.dx + outterArcDistance * math.sin(angleEndTime * math.pi / 180);
    final double outterArcPointerStartY =
        center.dy + outterArcDistance * -math.cos(angleEndTime * math.pi / 180);
    final double outterArcPointerEndX = center.dx +
        (outterArcDistance - outterArcLength) *
            math.sin(angleEndTime * math.pi / 180);
    final double outterArcPointerEndY = center.dy +
        (outterArcDistance - outterArcLength) *
            -math.cos(angleEndTime * math.pi / 180);

    canvas.drawLine(Offset(outterArcPointerEndX, outterArcPointerEndY),
        Offset(outterArcPointerStartX, outterArcPointerStartY), arcPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerArcDistance),
      ((angleTime - 90) * math.pi / 180),
      ((angleEndTime) * math.pi / 180),
      false,
      innerArcPaint,
    );
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return oldDelegate.currentTime != currentTime || oldDelegate.alarmData != alarmData;
  }
}

class PointerProperties {
  final double length;
  final Paint paint;

  PointerProperties({required this.length, required this.paint});
}
