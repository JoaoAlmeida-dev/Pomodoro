//
//
// import 'package:pomodoro/clock/models/alarm_data.dart';
//
// class QueueController {
//   final List<AlarmData> _alarmFifoQueue = <AlarmData>[];
//
//   QueueController();
//
//   bool get hasAlarm => _alarmFifoQueue.isNotEmpty;
//
//   AlarmData? get currentAlarm {
//     if (hasAlarm) return _alarmFifoQueue[0];
//     return null;
//   }
//
//   List<AlarmData> get alarms => _alarmFifoQueue.toList();
//
//   void addAlarm(Duration duration) {
//     AlarmData newAlarm;
//     DateTime _currentTime = DateTime.now();
//     if (hasAlarm) {
//       newAlarm = AlarmData(
//           startTime: _alarmFifoQueue.last.endTime,
//           endTime: _alarmFifoQueue.last.endTime.add(duration));
//     } else {
//       newAlarm = AlarmData(
//           startTime: _currentTime, endTime: _currentTime.add(duration));
//     }
//     _add(newAlarm);
//   }
//
//   void _add(AlarmData alarm) => _alarmFifoQueue.add(alarm);
//
//   void _addALll(Iterable<AlarmData> alarm) => _alarmFifoQueue.addAll(alarm);
//
//   void _insertFirst(AlarmData alarm) => _alarmFifoQueue.insert(0, alarm);
//
//   void _removeFirst() => _alarmFifoQueue.removeAt(0);
//
//   AlarmData? popAndGetNext() {
//     _removeFirst();
//
//     if (_alarmFifoQueue.isEmpty) return null;
//     return _alarmFifoQueue.first;
//   }
//
//   void clear() => _alarmFifoQueue.clear();
// }
