import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/clock/controller/alarm_queue_cubit/alarm_queue_cubit.dart';
import 'package:pomodoro/clock/controller/clock_theme/clock_theme_cubit.dart';
import 'package:pomodoro/clock/models/alarm_data.dart';
import 'package:pomodoro/extensions/datetime_extensions.dart';
import 'package:pomodoro/routes.dart';
import 'package:pomodoro/services/notification_service/notification_service.dart';

import 'clock/clock_theme_selector.dart';
import 'clock/clock_widget.dart';

void main() async {
  // Be sure to add this line if initialize() call happens before runApp()
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize();
  await AndroidAlarmManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClockThemeCubit>(create: (context) => ClockThemeCubit()),
        BlocProvider<AlarmQueueCubit>(create: (context) => AlarmQueueCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: Routes.list,
        initialRoute: Routes.initial,
        navigatorKey: Routes.navigatorKey,
      ),
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({
    super.key,
  });

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer timer;
  static const platform = MethodChannel('samples.flutter.dev/alarm');
  //final QueueController _queueController = QueueController();

  @override
  void dispose() {
    super.dispose();
    //timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    NotificationService.checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet: BottomSheet(
      //   clipBehavior: Clip.antiAliasWithSaveLayer,
      //   onClosing: () {},
      //   enableDrag: false,
      //   builder: (context) => ,
      // ),

      body: BlocBuilder<AlarmQueueCubit, AlarmQueueState>(
        builder: (context, state) {
          return SafeArea(
            bottom: true,
            maintainBottomViewPadding: true,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: OrientationBuilder(
                  builder: (context, Orientation orientation) {
                var clockWidget = Flexible(
                  flex: 2,
                  child: SizedBox.expand(
                    child: InteractiveViewer(
                      maxScale: 10,
                      child: const Clock(),
                    ),
                  ),
                );

                List<Widget> children = [
                  const Flexible(
                    flex: 1,
                    child: ClockThemeSelector(),
                  ),
                  if (state.hasAlarm)
                    Flexible(
                      flex: 1,
                      child: Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.alarms.length,
                          itemBuilder: (context, index) {
                            AlarmData alarm = state.alarms[index];
                            var durationLeft = alarm.totalDuration;
                            return ListTile(
                              title: Text(durationLeft.format()),
                              leading: index == 0
                                  ? Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : null,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(DateFormat("'startTime:' y/M/d H:m:s:S")
                                      .format(alarm.startTime)),
                                  Text(DateFormat("'endTime:' y/M/d H:m:s:S")
                                      .format(alarm.endTime)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  Flexible(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () =>
                                BlocProvider.of<AlarmQueueCubit>(context)
                                    .clear(),
                            child: const Text("Clear list"),
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
                                        title:
                                            const Text("Choose the duration"),
                                        content: DropdownButton<int>(
                                          menuMaxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
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
                  )
                ];

                switch (orientation) {
                  case Orientation.portrait:
                    return Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      direction: Axis.vertical,
                      children: [clockWidget, ...children],
                    );
                  case Orientation.landscape:
                    return Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Flex(
                            direction: Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          ),
                        ),
                        clockWidget,
                      ],
                    );
                    break;
                }
              }),
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> addNewAlarm(Duration? value) async {
    if (value == null) return;
    BlocProvider.of<AlarmQueueCubit>(context).addAlarm(value);
    //setState(() {
    //  _queueController.addAlarm(value);
    //});
  }
}
