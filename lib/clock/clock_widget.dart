import 'package:flutter/material.dart';
import 'package:pomodoro/clock/clock_foreground_painter.dart';
import 'package:pomodoro/clock/clock_background_painter.dart';
import 'package:pomodoro/clock/models/alarm_data.dart';

class Clock extends StatelessWidget {
  final AlarmData? alarmData;

  const Clock({Key? key, this.alarmData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: ClockForegroundPainter(
        currentTime: DateTime.now(),
        alarmData: alarmData,
        displayCenterAlarmTime: true,
        primaryMaterialColor: Colors.green,
      ),
      painter: ClockBackgroundPainter(
        primaryMaterialColor: Colors.blueGrey,
      ),
    );
  }
}
