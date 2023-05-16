import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/clock/clock_background_painter.dart';
import 'package:pomodoro/clock/clock_foreground_painter.dart';
import 'package:pomodoro/clock/controller/alarm_queue_cubit/alarm_queue_cubit.dart';
import 'package:pomodoro/clock/controller/clock_theme/clock_theme_cubit.dart';

class Clock extends StatefulWidget {
  //final AlarmData? alarmData;

  //const Clock({Key? key, this.alarmData}) : super(key: key);
  const Clock({Key? key}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockThemeCubit, ClockThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AlarmQueueCubit, AlarmQueueState>(
          builder: (context, alarmQueueState) {
            return AnimatedBuilder(
                animation: animationController,
                builder: (context, _) {
                  return CustomPaint(
                    foregroundPainter: ClockForegroundPainter(
                      currentTime: DateTime.now(),
                      alarmData: alarmQueueState.currentAlarm,
                      displayCenterAlarmTime: true,
                      primaryMaterialColor: themeState.foreground,
                    ),
                    painter: ClockBackgroundPainter(
                      primaryMaterialColor: themeState.background,
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
