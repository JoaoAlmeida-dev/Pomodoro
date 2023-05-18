import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pomodoro/clock/models/alarm_data.dart';
import 'package:pomodoro/services/notification_service/notification_service.dart';

part 'alarm_queue_state.dart';

class AlarmQueueCubit extends Cubit<AlarmQueueState> {
  AlarmQueueCubit() : super(const AlarmQueueState(alarmQueue: []));
  Timer? timer;

  void addAlarm(Duration duration) {
    AlarmData newAlarm;
    DateTime currentTime = DateTime.now();
    if (state.hasAlarm) {
      newAlarm = AlarmData(
          startTime: state.alarms.last.endTime,
          endTime: state.alarms.last.endTime.add(duration));
      emit(AlarmQueueState(alarmQueue: state.alarms..add(newAlarm)));
    } else {
      newAlarm =
          AlarmData(startTime: currentTime, endTime: currentTime.add(duration));

      emit(AlarmQueueState(alarmQueue: state.alarms..add(newAlarm)));
      _startNewAlarm();
    }
  }

  void popAndGetNext() {
    List<AlarmData> newAlarmsList = [...state.alarms];
    newAlarmsList.removeAt(0);
    if (state.alarms.isEmpty) {
      emit(const AlarmQueueState(alarmQueue: []));
      return;
    }
    emit(AlarmQueueState(alarmQueue: newAlarmsList));
    _startNewAlarm();
  }

  void _startNewAlarm() {
    if (!state.hasAlarm) return;
    /*AlarmWrapper.oneShotAt(
      state.currentAlarm!.endTime,
    );
*/
    NotificationService.scheduleBigTextNotification(
      title: "Alarm finished",
      body: "Time to go back to studying",
      time: state.currentAlarm!.endTime,
    );

    timer = timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (state.hasAlarm) {
        if (state.currentAlarm!.durationLeftFromNow().isNegative) {
          log("Alarm ended resetting state");
          popAndGetNext();
          timer.cancel();
        }
      }
    });
  }

  void clear() => emit(const AlarmQueueState(alarmQueue: []));
}
