import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/clock/clock_painter.dart';
import 'package:pomodoro/clock/controller/queueController.dart';
import 'package:pomodoro/clock/models/alarm_data.dart';

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
  late Timer timer;
  final QueueController _queueController = QueueController();

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
                onPressed: () => _queueController.clear(),
                child: Text("Clear list"),
              ),
              TextButton(
                  onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          List<int> items = List<int>.generate(
                            60.floor(),
                            (index) => index + 1,
                          );
                          return AlertDialog(
                            title: const Text("Choose the duration"),
                            content: DropdownButton<int>(
                              items: items
                                  .map(
                                    (e) => DropdownMenuItem<int>(
                                      value: e,
                                      child: Text(
                                        e.toString(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (int? value) {
                                if (value != null) {
                                  addNewAlarm(
                                    Duration(minutes: value),
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          );
                        },
                      ),
                  child: const Text("Add new alarm")),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        maintainBottomViewPadding: true,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      DateFormat("'Now:' H:m:s:S").format(_currentTime),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Expanded(
                      child: InteractiveViewer(
                        maxScale: 10,
                        child: SizedBox.expand(
                          child: CustomPaint(
                            painter: ClockPainter(
                              primaryMaterialColor: Colors.brown,
                              timediffNegativeColor: Colors.redAccent,
                              //timediffPositiveColor: Colors.black,
                              currentTime: _currentTime,
                              alarmData: _queueController.currentAlarm,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_queueController.hasAlarm)
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _queueController.alarms
                          .map(
                            (alarm) => ListTile(
                              title: Text(alarm.totalDuration.toString()),
                              subtitle: Column(
                                children: [
                                  Text(DateFormat("'startTime:' y/M/d H:m:s:S")
                                      .format(alarm.startTime)),
                                  Text(DateFormat("'endTime:' y/M/d H:m:s:S")
                                      .format(alarm.endTime)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              if (_queueController.hasAlarm)
                Builder(builder: (context) {
                  var durationLeft =
                      _queueController.currentAlarm!.durationLeftFromNow();
                  return Text(
                    durationLeft.inMinutes > 1
                        ? "Difference: ${durationLeft.inMinutes}m:${durationLeft.inSeconds - durationLeft.inMinutes * 60}s"
                        : "Difference: ${durationLeft.inSeconds} seconds",
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  FutureOr<void> addNewAlarm(Duration? value) async {
    if (value == null) return;

    setState(() {
      _queueController.addAlarm(value);
    });
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
        if (_queueController.hasAlarm) {
          if (_queueController.currentAlarm!.durationLeftFromNow().isNegative) {
            log("Alarm ended resetting state");
            _queueController.popAndGetNext();
          }
        }
      });
    });
  }
}
