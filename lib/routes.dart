import 'package:flutter/cupertino.dart';

import 'main.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    "/home": (_) => const ClockPage(),
  };

  static String initial = "/home";
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
