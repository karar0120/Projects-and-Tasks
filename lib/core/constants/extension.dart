import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension WeekEndDay on DateTime {
  String weekEndDay(other) {
    if (other.weekday == 1) {
      return "Monday";
    } else if (other.weekday == 2) {
      return "Tuesday";
    } else if (other.weekday == 3) {
      return "Wednesday";
    } else if (other.weekday == 4) {
      return "Thursday";
    } else if (other.weekday == 5) {
      return "Friday";
    }
    if (other.weekday == 6) {
      return "Saturday";
    } else {
      return "Sunday";
    }
  }
}

extension MonthName on DateTime {
  String monthName(other) {
    if (other.month == 1) {
      return "January";
    } else if (other.month == 2) {
      return "February";
    } else if (other.month == 3) {
      return "March";
    } else if (other.month == 4) {
      return "April";
    } else if (other.month == 5) {
      return "May";
    } else if (other.month == 6) {
      return "June";
    } else if (other.month == 7) {
      return "July";
    } else if (other.month == 8) {
      return "August";
    } else if (other.month == 9) {
      return "September";
    } else if (other.month == 10) {
      return "October";
    } else if (other.month == 11) {
      return "November";
    } else {
      return "December";
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}

extension ReplaceAllPermissionsWith on String {
  String replacePermissions() {
    return replaceAll('_', '.');
  }
}

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}
extension GetDayOfWeekName on int {
  String getDayOfWeekName() {
    switch (this) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }
}
extension ReplacePlaceholder on String{
  String replacePlaceholder(String placeholder, String value) {
    return replaceAll(placeholder, value);
  }
}