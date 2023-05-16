part of 'alarm_queue_cubit.dart';

@immutable
class AlarmQueueState {
  const AlarmQueueState({required List<AlarmData> alarmQueue})
      : _alarmFifoQueue = alarmQueue;

  final List<AlarmData> _alarmFifoQueue;

  bool get hasAlarm => _alarmFifoQueue.isNotEmpty;

  AlarmData? get currentAlarm {
    if (hasAlarm) return _alarmFifoQueue[0];
    return null;
  }

  List<AlarmData> get alarms => _alarmFifoQueue.toList();
}
