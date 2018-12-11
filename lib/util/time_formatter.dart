
class TimeFormatter {
  String formatTime(int seconds) {
    double minutes = (seconds / 60);
    double hours = (minutes / 60);
    if (hours.floor() == 0) {
      return '${minutes.toStringAsFixed(0)} Min.';
    } else {
      double mins = minutes % 60;
      return '${hours.floor()} h ${mins.floor()} Min.';
    }
  }
}