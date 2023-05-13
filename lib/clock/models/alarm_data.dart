class AlarmData {
  final DateTime startTime;
  final DateTime endTime;
  final Duration totalDuration;
  AlarmData({required this.startTime, required this.endTime})
      : totalDuration = endTime.difference(startTime);

  Duration durationLeft(DateTime currentTime) =>
      currentTime.difference(endTime);
  Duration durationLeftFromNow() => endTime.difference(DateTime.now());

  double currentPercentage(DateTime currentTime) {
    return 100 *
        durationLeft(currentTime).inMilliseconds /
        totalDuration.inMilliseconds;
  }
}
