import 'dart:async';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ClockPage(),
    );
  }
}

class _ClockPageState extends State<ClockPage> {
  DateTime _currentTime = DateTime.now();
  DateTime _endTime = DateTime(2023, 5, 10, 23, 00);
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    _endTime = DateTime(2023,6, 10, 23, 18);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          DateFormat("'now:' y/M/d H:m:s:S").format(_currentTime),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: CustomPaint(
            painter: ClockPainter(
              time: _currentTime,
              endTime: _endTime,
            ),
          ),
        ),
        Text(
          DateFormat("'endTime:' y/M/d H:m:s:S").format(_endTime),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
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
      });
    });
  }
}
