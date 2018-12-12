
import 'package:flutter/material.dart';
import 'package:track_it/util/localization.dart';

class TimeFormatter {
  String formatTime(BuildContext context, int seconds) {
    String daysText = Localization.of(context).days;
    String hourText = Localization.of(context).hours;
    String minText = Localization.of(context).minutes;

    double minutes = (seconds / 60);
    double hours = (minutes / 60);

    if (hours > 24) {
      double days = hours / 24;
      double hrs = hours % 24;

      return '${days.floor()} $daysText ${hrs.floor()} $hourText';
    }

    if (hours.floor() == 0) {
      return '${minutes.toStringAsFixed(0)} $minText';
    } else {
      double mins = minutes % 60;
      return '${hours.floor()} $hourText ${mins.floor()} $minText';
    }
  }
}