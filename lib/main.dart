import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/clock/clock_painter.dart';

void main() {
  runApp(const MyApp());
}

class ClockPage extends StatefulWidget {
  const ClockPage({
    super.key,
  });

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClockPage();
  }
}

class _ClockPageState extends State<ClockPage> {
  DateTime _currentTime = DateTime.now();
  DateTime? _alarmTime;
  Duration? timeDiff;
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        onClosing: () {},
        enableDrag: false,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_currentTime),
                    ).then(
                      (var value) => setState(() {
                        if (value != null) {
                          _alarmTime = DateTime(
                            _currentTime.year,
                            _currentTime.month,
                            _currentTime.day,
                            value.hour,
                            value.minute,
                          );
                          if (_alarmTime!.difference(_currentTime).isNegative) {
                            _alarmTime = DateTime(
                              _currentTime.year,
                              _currentTime.month,
                              _currentTime.day + 1,
                              value.hour,
                              value.minute,
                            );
                          }
                          timeDiff = _alarmTime!.difference(_currentTime);
                        }
                      }),
                    );
                  },
                  child: const Text("Choose new alarm")),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        maintainBottomViewPadding: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("'Now:' y/M/d H:m:s:S").format(_currentTime),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: CustomPaint(
                painter: ClockPainter(
                  primaryColor: Colors.brown,
                  timediffNegativeColor: Colors.redAccent,
                  //timediffPositiveColor: Colors.black,
                  time: _currentTime,
                  endTime: _alarmTime,
                ),
              ),
            ),
            if (_alarmTime != null)
              Text(
                DateFormat("'Alarm:' y/M/d H:m:s:S").format(_alarmTime!),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            if (timeDiff != null)
              Text(
                timeDiff!.inMinutes > 1
                    ? "Difference: ${timeDiff!.inMinutes}m:${timeDiff!.inSeconds - timeDiff!.inMinutes * 60}s"
                    : "Difference: ${timeDiff!.inSeconds} seconds",
                style: Theme.of(context).textTheme.titleLarge,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        if (_alarmTime != null) {
          timeDiff = _alarmTime!.difference(_currentTime);
          if (timeDiff!.isNegative) {
            log("Alarm ended resetting state");
            timeDiff = null;
            _alarmTime = null;
          }
        }
      });
    });
  }
}
