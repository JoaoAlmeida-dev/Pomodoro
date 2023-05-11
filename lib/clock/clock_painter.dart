import 'dart:math' as math;

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime time;
  final DateTime? endTime;
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
  final MaterialColor primaryColor;


  ClockPainter({required this.time,
    required this.endTime,
    required this.primaryColor,
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
  })
      : _borderColor = borderColor ?? primaryColor.shade900,
        _backgroundColor = backgroundColor ?? primaryColor.shade800,
        _hourPointerColor = hourPointerColor ?? primaryColor.shade700,
        _minPointerColor = minPointerColor ?? primaryColor.shade500,
        _secPointerColor = secPointerColor ?? primaryColor.shade200,
        _minTextColor = minTextColor ?? primaryColor.shade200,
        _hour12TextColor = hour12TextColor ?? primaryColor.shade200,
        _hour24TextColor = hour24TextColor ?? primaryColor.shade200,
        _timediffPositiveColor = timediffPositiveColor ?? primaryColor.shade200,
        _timediffNegativeColor = timediffNegativeColor ?? primaryColor.shade800
  ;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Offset center = Offset(centerX, centerY);
    final double radius = math.min(centerX, centerY);

    final fillBrush = Paint()
      ..color = _backgroundColor;
    final outLineBrush = Paint()
      ..color = _borderColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;
    final centerDotBrush = Paint()
      ..color = _borderColor;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outLineBrush);

    //paint12HourTexts(canvas: canvas, center: center, radius: radius);
    paint24HourTexts(canvas: canvas, center: center, radius: radius);
    paint12HourInfo(
        canvas: canvas, center: center, radius: radius);
    paintMinutes(canvas: canvas, center: center, radius: radius);

    paintClockHands(canvas: canvas, center: center, radius: radius);
    if (endTime != null) {
      paintTimeDifference(canvas: canvas,
          center: center,
          radius: radius,
          endTime: endTime!,
          startTime: time);
    }

    canvas.drawCircle(center, 16, centerDotBrush);
  }

  void paint24HourTexts({
    required Canvas canvas,
    required Offset center,
    required double radius,
  }) {
    TextStyle textStyle = TextStyle(
      color: _hour24TextColor,
      fontSize: 20,
    );
    double distanceFromCenter = radius * 0.4;

    List < ({int angle, int hour}) > hourAngleList = [
      (hour:24, angle:0),
      (hour:6, angle:90),
      (hour:12, angle:180),
      (hour:18, angle:270)
    ];

    for (({int angle, int hour}) hourAngle in hourAngleList) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: hourAngle.hour.toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: 40);


      double x1 = center.dx - textPainter.width / 2 +
          distanceFromCenter * math.sin(hourAngle.angle * math.pi / 180);
      double y1 = center.dy - textPainter.height / 2 +
          distanceFromCenter * -math.cos(hourAngle.angle * math.pi / 180);


      textPainter.paint(canvas, Offset(x1, y1));
    }
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
        ..color = _hourPointerColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 15,
    );

    final minProperties = PointerProperties(
      length: 0.4,
      paint: Paint()
        ..strokeCap = StrokeCap.round
        ..color = _minPointerColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    final secProperties = PointerProperties(
      length: 0.6,
      paint: Paint()
      //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
        ..color = _secPointerColor
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

  void paint12HourInfo({
    required Canvas canvas,
    required Offset center,
    required double radius,
  }) {
    final Paint lineBrush = Paint()
    //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..color = _borderColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    TextStyle textStyle = TextStyle(
      color: _hour12TextColor,
      fontSize: 20,
    );

    double hourDistanceFromCenter = radius * 0.6;
    double outterLineDistance = radius * 0.8;
    double innerLineDistance = radius * 0.7;
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
      )
        ..layout(minWidth: 0, maxWidth: 40);


      double hourX1 = center.dx - textPainter.width / 2 +
          hourDistanceFromCenter * math.sin(i * math.pi / 180);
      double hourY1 = center.dy - textPainter.height / 2 +
          hourDistanceFromCenter * -math.cos(i * math.pi / 180);

      textPainter.paint(canvas, Offset(hourX1, hourY1));
    }
  }

  void paintMinutes({
    required Canvas canvas,
    required Offset center,
    required double radius,
  }) {
    TextStyle textStyle = TextStyle(
      color: _minTextColor,
      fontSize: 10,
    );
    double distanceFromCenter = radius * 0.77;


    for (int i = 0; i < 360; i += 6) {
      if (i % 30 == 0) {
        int minute = i == 0 ? 60 : (i * 60 / 360).floor();
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: minute.toString(),
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: 40);


        double x1 = center.dx - textPainter.width / 2 +
            distanceFromCenter * math.sin(i * math.pi / 180);
        double y1 = center.dy - textPainter.height / 2 +
            distanceFromCenter * -math.cos(i * math.pi / 180);


        textPainter.paint(canvas, Offset(x1, y1));
      } else {
        final Paint lineBrush = Paint()
        //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
          ..color = _backgroundColor
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        var outterLineDistance = radius * 0.8;
        var innerLineDistance = radius * 0.75;

        double linex1 = center.dx +
            outterLineDistance * math.sin(i * math.pi / 180);
        double liney1 = center.dy +
            outterLineDistance * -math.cos(i * math.pi / 180);

        double linex2 = center.dx +
            innerLineDistance * math.sin(i * math.pi / 180);
        double liney2 = center.dy +
            innerLineDistance * -math.cos(i * math.pi / 180);

        canvas.drawLine(
            Offset(linex1, liney1), Offset(linex2, liney2), lineBrush);
      }
    }
  }

  void paintTimeDifference({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required DateTime endTime,
    required DateTime startTime
  }) {
    Duration timeDifference = endTime.difference(startTime);
    final Paint arcPaint = Paint()
    //..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.pink]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..color = !timeDifference.isNegative ? _timediffPositiveColor : _timediffNegativeColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin=StrokeJoin.bevel
    ;


    var angleTime = 0;

    var minutesDifference = timeDifference.inMinutes -
        timeDifference.inHours * 60;
    var secondsDifference = timeDifference.inSeconds -
        timeDifference.inMinutes * 60;
    var angleEndTime = minutesDifference * 6 +
        secondsDifference * 0.1; //+  milliSecondsDifference * 0.0001;



    Paint timerPointerPaint=arcPaint..strokeWidth=3;


    final double outterArcDistance =radius * 0.82;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outterArcDistance),
      ((angleTime - 90) * math.pi / 180),
      ((angleEndTime) * math.pi / 180),
      false,
      arcPaint,
    );
    final double outterArcLength =radius * 0.03;
    final double outterArcPointerStartX = center.dx + outterArcDistance * math.sin(angleEndTime * math.pi / 180);
    final double outterArcPointerStartY = center.dy + outterArcDistance * -math.cos(angleEndTime * math.pi / 180);
    final double outterArcPointerEndX = center.dx + (outterArcDistance-outterArcLength) * math.sin(angleEndTime * math.pi / 180);
    final double outterArcPointerEndY = center.dy + (outterArcDistance-outterArcLength) * -math.cos(angleEndTime * math.pi / 180);
    canvas.drawLine(Offset(outterArcPointerEndX, outterArcPointerEndY) ,Offset(outterArcPointerStartX, outterArcPointerStartY) ,timerPointerPaint);

    final double innerArcDistance =radius * 0.09;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerArcDistance),
      ((angleTime - 90) * math.pi / 180),
      ((angleEndTime) * math.pi / 180),
      false,
      arcPaint,
    );


  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.endTime != endTime;
  }

}

class PointerProperties {
  final double length;
  final Paint paint;

  PointerProperties({required this.length, required this.paint});
}
