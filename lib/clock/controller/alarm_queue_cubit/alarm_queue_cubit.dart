import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pomodoro/clock/models/alarm_data.dart';

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
      timer =
          timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (state.hasAlarm) {
          if (state.currentAlarm!.durationLeftFromNow().isNegative) {
            log("Alarm ended resetting state");
            popAndGetNext();
            timer.cancel();
          }
        }
      });

      emit(AlarmQueueState(alarmQueue: state.alarms..add(newAlarm)));
    }
  }

  void popAndGetNext() {
    List<AlarmData> newAlarmsList = [...state.alarms];
    newAlarmsList.removeAt(0);
    if (state.alarms.isEmpty) {
      emit(const AlarmQueueState(alarmQueue: []));
    }
    timer = timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (state.hasAlarm) {
        if (state.currentAlarm!.durationLeftFromNow().isNegative) {
          log("Alarm ended resetting state");
          popAndGetNext();
          timer.cancel();
        }
      }
    });
    emit(
      AlarmQueueState(alarmQueue: newAlarmsList),
    );
  }

  void clear() => emit(const AlarmQueueState(alarmQueue: []));
}
