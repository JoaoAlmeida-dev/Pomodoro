import 'package:flutter/cupertino.dart';
import 'package:pomodoro/alarm_page.dart';

import 'main.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    initial: (_) => const ClockPage(),
    alarmPage: (_) => const AlarmPage(),
  };

  static String initial = "/home";
  static String alarmPage = "/alarm";
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
