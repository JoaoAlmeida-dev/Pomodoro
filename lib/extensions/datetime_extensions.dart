extension StringFormat on Duration {
  String format() {
    if (inHours > 1) {
      return "${inHours}h:${inMinutes - inHours * 60}m:${inSeconds - inMinutes * 60}s";
    }
    if (inMinutes > 1) {
      return "${inMinutes}m:${inSeconds - inMinutes * 60}s";
    }
    return "$inSeconds seconds";
  }
}
