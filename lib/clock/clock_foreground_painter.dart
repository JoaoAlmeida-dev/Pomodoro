import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/clock/clock_background_painter.dart';
import 'package:pomodoro/clock/models/alarm_data.dart';
import 'package:pomodoro/extensions/datetime_extensions.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:math' as math;

class ClockForegroundPainter extends CustomPainter {
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
  final bool displayCenterTime;
  final bool displayCenterAlarmTime;
  final bool displayAlarmRemainingTimeLines;
  final MaterialColor primaryMaterialColor;
  final bool hasCenterText;

  ClockForegroundPainter({
    required this.currentTime,
    required this.primaryMaterialColor,
    this.alarmData,
    this.displayCenterTime = false,
    this.displayCenterAlarmTime = false,
    this.displayAlarmRemainingTimeLines = true,
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
        _hourPointerColor = hourPointerColor ?? primaryMaterialColor.shade700,
        _minPointerColor = minPointerColor ?? primaryMaterialColor.shade500,
        _secPointerColor = secPointerColor ?? primaryMaterialColor.shade200,
        _minTextColor = minTextColor ?? primaryMaterialColor.shade200,
        _hour12TextColor = hour12TextColor ?? primaryMaterialColor.shade200,
        _hour24TextColor = hour24TextColor ?? primaryMaterialColor.shade200,
        _timediffPositiveColor =
            timediffPositiveColor ?? primaryMaterialColor.shade200,
        _timediffNegativeColor =
            timediffNegativeColor ?? primaryMaterialColor.shade800,
        hasCenterText =
            displayCenterTime || (displayCenterAlarmTime && alarmData != null);

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

    double outterBorderCircleRadius = radius * 0.9;
    double backgroundCircleRadius = radius * 0.8;
    double outterBorderWidth =
        outterBorderCircleRadius - backgroundCircleRadius;
    double centerCircleRadius = radius * 0.05;
    double centerTextFontSize = radius * 0.15;

    final hourProperties = PointerProperties(
      length: backgroundCircleRadius * 0.4,
      paint: Paint()
        ..color = _hourPointerColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = radius * 0.05,
    );

    final minProperties = PointerProperties(
      length: backgroundCircleRadius * 0.6,
      paint: Paint()
        ..strokeCap = StrokeCap.round
        ..color = _minPointerColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.03,
    );

    final secProperties = PointerProperties(
      length: backgroundCircleRadius * 0.8,
      paint: Paint()
        ..color = _secPointerColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.01,
    );

    paintClockHands(
      canvas: canvas,
      center: center,
      radius: radius,
      hourProperties: hourProperties,
      minProperties: minProperties,
      secProperties: secProperties,
    );

    if (alarmData != null) {
      final Duration timeDifference =
          alarmData!.endTime.difference(alarmData!.startTime);
      final double outterArcLength = outterBorderWidth * 0.5;

      const double angleTime = 0;
      final double angleEndTime =
          alarmData!.currentPercentage(currentTime) * -360 / 100;

      final Paint arcPaint = Paint()
        ..color = !timeDifference.isNegative
            ? _timediffPositiveColor
            : _timediffNegativeColor
        ..strokeCap = StrokeCap.square
        ..style = PaintingStyle.stroke
        ..strokeWidth = outterArcLength;

      final Color innerArcColor = !timeDifference.isNegative
          ? _timediffPositiveColor
          : _timediffNegativeColor;
      final Paint innerArcPaint = Paint()
        ..color = innerArcColor
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke
        ..strokeWidth = outterArcLength;

      if (displayAlarmRemainingTimeLines && alarmData != null) {
        paintOutterTimeDifference(
          canvas: canvas,
          center: center,
          outterArcDistance: outterBorderCircleRadius,
          arcPaint: arcPaint,
          endAngle: angleEndTime,
          startAngle: angleTime,
          outterArcLength: outterArcLength,
        );

        String time =
            intl.DateFormat("H'h':m'm'").format(currentTime).toString();
        String? alarmTime = alarmData?.durationLeftFromNow().format();
        String? centerText;

        if (displayCenterTime && !displayCenterAlarmTime) centerText = time;
        if (!displayCenterTime && displayCenterAlarmTime)
          centerText = alarmTime;
        if (displayCenterTime && displayCenterAlarmTime) {
          centerText = alarmData != null ? alarmTime : time;
        }
        if (centerText != null) {
          paintCenterTextProgress(
            innerArcColor: innerArcColor,
            canvas: canvas,
            center: center,
            centerCircleRadius: centerCircleRadius,
            centerDotBrush: centerDotBrush,
            centerTextFontSize: centerTextFontSize,
            backgroundCircleRadius: backgroundCircleRadius,
            outterArcDistance: outterBorderCircleRadius,
            centerText: centerText,
            endAngle: angleEndTime,
            startAngle: angleTime,
            outterArcLength: outterArcLength,
          );
        } else {
          paintInnerTimeDifference(
            canvas: canvas,
            center: center,
            innerArcDistance: centerCircleRadius,
            innerArcPaint: innerArcPaint,
            endAngle: angleEndTime,
            startAngle: angleTime,
          );
          canvas.drawPath(
            Path()
              ..addOval(
                  Rect.fromCircle(center: center, radius: centerCircleRadius))
              ..close(),
            centerDotBrush,
          );
        }
      }
    } else {
      canvas.drawPath(
        Path()
          ..addOval(Rect.fromCircle(center: center, radius: centerCircleRadius))
          ..close(),
        centerDotBrush,
      );
    }

    if (displayCenterTime || displayCenterAlarmTime) {
      String time = intl.DateFormat("H'h':m'm'").format(currentTime).toString();
      String? alarmTime = alarmData?.durationLeftFromNow().format();
      String? centerText;

      if (displayCenterTime && !displayCenterAlarmTime) centerText = time;
      if (!displayCenterTime && displayCenterAlarmTime) centerText = alarmTime;
      if (displayCenterTime && displayCenterAlarmTime) {
        centerText = alarmData != null ? alarmTime : time;
      }

      if (centerText != null) {
        paintCenterText(
          canvas: canvas,
          center: center,
          centerCircleRadius: centerCircleRadius,
          centerDotBrush: centerDotBrush,
          centerTextFontSize: centerTextFontSize,
          backgroundCircleRadius: backgroundCircleRadius,
          centerText: centerText,
        );
      }
    }
  }

  void paintInnerTimeDifference({
    required Canvas canvas,
    required Offset center,
    required double innerArcDistance,
    required double startAngle,
    required double endAngle,
    required Paint innerArcPaint,
  }) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerArcDistance),
      ((startAngle - 90) * math.pi / 180),
      ((endAngle) * math.pi / 180),
      false,
      innerArcPaint,
    );
  }

  void paintOutterTimeDifference({
    required Canvas canvas,
    required Offset center,
    required double outterArcDistance,
    required double outterArcLength,
    required double startAngle,
    required double endAngle,
    required Paint arcPaint,
  }) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outterArcDistance),
      ((startAngle - 90) * math.pi / 180),
      ((endAngle) * math.pi / 180),
      false,
      arcPaint,
    );

    final double outterArcPointerStartX =
        center.dx + outterArcDistance * math.sin(endAngle * math.pi / 180);
    final double outterArcPointerStartY =
        center.dy + outterArcDistance * -math.cos(endAngle * math.pi / 180);
    final double outterArcPointerEndX = center.dx +
        (outterArcDistance - outterArcLength) *
            math.sin(endAngle * math.pi / 180);
    final double outterArcPointerEndY = center.dy +
        (outterArcDistance - outterArcLength) *
            -math.cos(endAngle * math.pi / 180);

    canvas.drawLine(Offset(outterArcPointerEndX, outterArcPointerEndY),
        Offset(outterArcPointerStartX, outterArcPointerStartY), arcPaint);
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

    final double minHandAngle =
        currentTime.minute * 6 + currentTime.second * 0.1;
    final double minHandX =
        centerX + minProperties.length * math.sin(minHandAngle * math.pi / 180);
    final double minHandY = centerY +
        minProperties.length * -math.cos(minHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minProperties.paint);

    final double secHandAngle =
        currentTime.second * 6 + currentTime.millisecond * 0.006;
    final double secHandX =
        centerX + secProperties.length * math.sin(secHandAngle * math.pi / 180);
    final double secHandY = centerY +
        secProperties.length * -math.cos(secHandAngle * math.pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secProperties.paint);
  }

  void paintCenterText({
    required Canvas canvas,
    required Offset center,
    required double centerCircleRadius,
    required Paint centerDotBrush,
    required double centerTextFontSize,
    required double backgroundCircleRadius,
    required String centerText,
  }) {
    TextStyle textStyle = TextStyle(
      color: _hour12TextColor,
      fontSize: centerTextFontSize,
      //backgroundColor: _backgroundColor,
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: centerText,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: backgroundCircleRadius * 2);

    double hourX1 = center.dx - textPainter.width / 2;
    double hourY1 = center.dy - textPainter.height / 2;
    var rect = Rect.fromLTWH(
      center.dx - textPainter.width * 0.75,
      center.dy - textPainter.height * 0.75,
      textPainter.width * 1.5,
      textPainter.height * 1.5,
    );

    canvas.drawOval(
      rect,
      Paint()..color = _borderColor,
    );
    textPainter.paint(canvas, Offset(hourX1, hourY1));
  }

  void paintCenterTextProgress({
    required Canvas canvas,
    required Offset center,
    required double centerCircleRadius,
    required Paint centerDotBrush,
    required double centerTextFontSize,
    required double backgroundCircleRadius,
    required String centerText,
    required double outterArcDistance,
    required double outterArcLength,
    required double startAngle,
    required double endAngle,
    required Color innerArcColor,
  }) {
    TextStyle textStyle = TextStyle(
      color: _hour12TextColor,
      fontSize: centerTextFontSize,
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: centerText,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: backgroundCircleRadius * 2);

    double hourX1 = center.dx - textPainter.width / 2;
    double hourY1 = center.dy - textPainter.height / 2;
    double ovalScale = 0.8;
    var rect = Rect.fromPoints(
        Offset(
          center.dx - textPainter.width * ovalScale,
          center.dy - textPainter.height * ovalScale,
        ),
        Offset(
          center.dx + textPainter.width * ovalScale,
          center.dy + textPainter.height * ovalScale,
        )
        // center.dx - textPainter.width * 0.85,
        // center.dy - textPainter.height * 0.85,
        // textPainter.width * 1.6,
        // textPainter.height * 1.6,
        );

    final double outterArcPointerStartX =
        center.dx + outterArcDistance * math.sin(startAngle * math.pi / 180);
    final double outterArcPointerStartY =
        center.dy + outterArcDistance * -math.cos(startAngle * math.pi / 180);
    final double outterArcPointerEndX =
        center.dx + (outterArcDistance) * math.sin(endAngle * math.pi / 180);
    final double outterArcPointerEndY =
        center.dy + (outterArcDistance) * -math.cos(endAngle * math.pi / 180);

    Path ovalPath = Path()..addOval(rect);
    Path centerProgressRemover = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(outterArcPointerStartX, outterArcPointerStartY)
      ..addArc(
        Rect.fromCircle(center: center, radius: outterArcDistance),
        ((startAngle - 90) * math.pi / 180),
        ((endAngle) * math.pi / 180),
      )
      ..lineTo(outterArcPointerEndX, outterArcPointerEndY)
      ..lineTo(center.dx, center.dy)
      ..close();

    Path centerProgressPath =
        Path.combine(PathOperation.intersect, ovalPath, centerProgressRemover);
    canvas.drawPath(centerProgressPath, Paint()..color = innerArcColor);
  }

  @override
  bool shouldRepaint(ClockForegroundPainter oldDelegate) {
    return oldDelegate.currentTime != currentTime ||
        oldDelegate.alarmData != alarmData;
  }
}
