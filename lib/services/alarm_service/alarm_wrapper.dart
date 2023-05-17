import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:pomodoro/services/logger/logger.dart';

class AlarmWrapper {
  static const int _oneShotTaskId = 1;
  static const int _oneShotAtTaskId = 2;
  static const int _periodicTaskId = 3;

  static Future<void> oneShot(Duration duration) async {
    Logger.debug(message: "Setup alarm oneShot in $duration");
    await AndroidAlarmManager.oneShot(
      duration,
      _oneShotTaskId,
      () => Logger.debug(message: "alarm oneShot in $duration"),
      alarmClock: true,
      wakeup: true,
      allowWhileIdle: true,
      exact: true,
    );
  }

  static Future<void> oneShotAt(DateTime chosenDate, Function callback) async {
    Logger.debug(message: "Setup alarm oneShotAt in $chosenDate");
    await AndroidAlarmManager.oneShotAt(
      chosenDate,
      _oneShotAtTaskId,
      callback,
      alarmClock: true,
      wakeup: true,
      allowWhileIdle: true,
      exact: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<void> periodic(Duration duration) async {
    Logger.debug(message: "Setup alarm oneShotAt in $duration");
    await AndroidAlarmManager.periodic(
      duration,
      _periodicTaskId,
      () => Logger.debug(message: "alarm oneShotAT $duration "),
      wakeup: true,
      allowWhileIdle: true,
      exact: true,
    );
  }
}
