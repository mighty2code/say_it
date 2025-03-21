import 'package:say_it/constants/date_formats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateConversion on String {
  String? toDateStringFor(
    String toFormat,
    String fromFormat,
  ) {
    var inputFormat = DateFormat(fromFormat);
    var inputDate = inputFormat.parse(this); // <-- dd/MM 24H format

    var outputFormat = DateFormat(toFormat);
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  DateTime? getDate() {
    DateTime? parsedDate = DateTime.tryParse(this);
    return parsedDate;
  }

  DateTime? getDateFromFormat(String format) {
    try {
      DateTime parsedDate = DateFormat(format).parse(this);
      return parsedDate;
    } catch (e) {
      debugPrint('DebugX: $e');
      return null;
    }
  }
}

extension HoursOnMins on int {
  getHoursFromMins() {
    final hours = (this ~/ 60);
    final mins = this % 60;
    if (hours <= 0 && mins <= 0) {
      return '0 hr';
    } else if (hours > 0 && mins == 0) {
      return '$hours${hours == 1 ? 'hr' : 'hrs'}';
    } else if (hours == 0 && mins > 0) {
      return '$mins${mins == 1 ? 'min' : 'mins'}';
    } else if (hours > 0 && mins > 0) {
      return '$hours${hours == 1 ? 'hr' : 'hrs'} $mins${mins == 1 ? 'min' : 'mins'}';
    }
    return '0 hr';
  }

  getHoursFromMinsCompact() {
    final hours = (this ~/ 60);
    final mins = this % 60;
    if (hours <= 0 && mins <= 0) {
      return '0h';
    } else if (hours > 0 && mins == 0) {
      return '${hours}h';
    } else if (hours == 0 && mins > 0) {
      return '${mins}m';
    } else if (hours > 0 && mins > 0) {
      return '${hours}h ${mins}m';
    }
    return '0h';
  }
}

extension DateFormating on DateTime {
  bool isSameDay(DateTime dateB) {
    return year == dateB.year && month == dateB.month && day == dateB.day;
  }

  String toDateString(
    String toFormat,
  ) {
    return DateFormat(toFormat).format(this);
  }

  /// Returns the difference (in full days) between the provided date and today.
  int calculateDifference() {
    DateTime now = DateTime.now();
    return DateTime(year, month, day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  /// Returns the difference (in mins) between the provided date and today.
  int calculateDifferenceInMins() {
    DateTime now = DateTime.now();
    //22:29:38--- 18:31:32
    //20:22:38 --- 20:31:38
    // result -60  120

    final dddd = DateTime(year, month, day, hour, minute, second, millisecond)
        .difference(DateTime(now.year, now.month, now.day, now.hour, now.minute,
            now.second, now.millisecond))
        .inMinutes;
    return dddd;
  }

  bool isCurrentDateTimeWithinBufferSlot({double slotHours=0}) {
    DateTime bufferDate = subtract(Duration(minutes: (slotHours*60).toInt()));
    // Get the current date and time
    DateTime currentDate = DateTime.now();
    
    debugPrint("DebugX: in isCurrentDateTimeWithinBufferSlot [extension.dart]");
    debugPrint("DebugX: currentDate $currentDate, bufferDate $bufferDate, this $this");
    
    // Check if the current date and time is within the calculated range (including equal time)
    if (currentDate.isAfter(bufferDate) && currentDate.isBefore(this) ||
        currentDate.isAtSameMomentAs(bufferDate) || currentDate.isAtSameMomentAs(this)) {
      debugPrint("DebugX: isCurrentDateTimeWithinBufferSlot = true");
      return true;
    }
    debugPrint("DebugX: isCurrentDateTimeWithinBufferSlot = false");
    return false;
  }

  bool isCurrentDateTimeAfterBuffer({double bufferTimeInHours=0}) {
    DateTime bufferDate = subtract(Duration(minutes: (bufferTimeInHours*60).toInt()));
    // Get the current date and time
    DateTime currentDate = DateTime.now();
    
    debugPrint("DebugX: in isCurrentDateTimeAfterBuffer [extension.dart]");
    debugPrint("DebugX: currentDate $currentDate, bufferDate $bufferDate, this $this");
    
    // Check if the current date and time is after given datetime
    if (currentDate.isAfter(bufferDate) || currentDate.isAtSameMomentAs(bufferDate)) {
      debugPrint("DebugX: isCurrentDateTimeAfterBuffer = true");
      return true;
    }
    debugPrint("DebugX: isCurrentDateTimeAfterBuffer = false");
    return false;
  }
}

/// DevChanges&FixesT108
extension DurationExtras on Duration {
  String getDurationTime({bool showSeconds = true}) {
    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);
    String time = '';

    if (hours > 0) {
      time += '$hours';
    }
    if (minutes > 0) {
      time += ': $minutes';
    }
    if(showSeconds && seconds > 0) {
      time += ': $seconds';
    }
    return time.trim();
  }

  String getDurationTimeInHHmmss({bool showSeconds = true}) {
    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);

    String formattedTime = '$hours: ${minutes.toString().padLeft(2, '0')}';

    if (showSeconds) {
      formattedTime += ': ${seconds.toString().padLeft(2, '0')}';
    }

    return formattedTime;
  }

  String getDurationTimeWithLabel() {
    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);
    String time = '';

    if (hours > 0) {
      time += '$hours Hr ';
    }
    if (minutes > 0) {
      time += '$minutes Min ';
    }
    time += '$seconds Sec';
    return time.trim();
  }
}

extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);
    if ((difference.inDays / 7).floor() >= 2) {
      return toDateString(DateFormats.ddMMMyyyy);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  /// Gets the hour in 12-hour format in String.
  String get minuteInTwoDigitString => minute <=9 ? '0$minute' : '$minute';

  /// Gets the hour in 12-hour format.
  int get hourInAmPm {
    int hour = this.hour % 12;
    return hour == 0 ? 12 : hour;
  }

  /// Gets the hour in 12-hour format in 2 digit String.
  String get hourInAmPmTwoDigitString => hourInAmPm <=9 ? '0$hourInAmPm' : '$hourInAmPm';

  /// Determines whether the time is AM or PM.
  String get period => hour < 12 ? 'AM' : 'PM';

  /// Determines if the period is AM.
  bool get periodIsAm => hour < 12;
  /// Determines if the period is PM.
  bool get periodIsPm => hour >= 12;
  DateTime get removeSeconds => DateTime(year, month, day, hour, minute);
  DateTime get date => DateTime(year, month, day);

  bool isAfterOrEqual(DateTime other) {
    return isAfter(other) || isSameDate(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    return isBefore(other) || isSameDate(other);
  }

  bool isSameDate(DateTime others) {
    return year == others.year && month == others.month && day == others.day;
  }

  DateTime firstDayOfMonth() {
    return DateTime(year, month, 1);
  }

  DateTime lastDayOfMonth() {
    return DateTime(year, month, daysInMonth());
  }

  int daysInMonth() {
    // List of days in each month for non-leap years
    List<int> daysInMonthList = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    // Check for February in a leap year
    if (month == 2) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        return 29;
      }
    }
    return daysInMonthList[month - 1];
  }

  DateTime yearsBefore([int year = 1]) {
    return subtractMonths(year * 12);
  }

  DateTime yearsAfter([int year = 1]) {
    return addMonths(year * 12);
  }

  DateTime addMonth() {
    return addMonths();
  }

  DateTime subtractMonth() {
    return subtractMonths();
  }

  DateTime addMonths([int months = 1]) {
    int newYear = year;
    int newMonth = month + months;

    while (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    // Handle the case where the new month has fewer days than the original date's day
    int newDay = day;
    int lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day; // 0th day of next month is the last day of the current month
    if (newDay > lastDayOfMonth) {
      newDay = lastDayOfMonth;
    }
    return DateTime(newYear, newMonth, newDay, hour, minute, second, millisecond, microsecond);
  }

  DateTime subtractMonths([int months = 1]) {
    int newYear = year;
    int newMonth = month - months;

    while (newMonth <= 0) {
      newYear--;
      newMonth += 12;
    }
    // Handle the case where the new month has fewer days than the original date's day
    int newDay = day;
    int lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day; // 0th day of next month is the last day of the current month
    if (newDay > lastDayOfMonth) {
      newDay = lastDayOfMonth;
    }
    return DateTime(newYear, newMonth, newDay, hour, minute, second, millisecond, microsecond);
  }

  DateTime addYear() {
    return addMonths(12);
  }

  DateTime subtractYear() {
    return subtractYears();
  }

  DateTime subtractYears([int years = 1]) {
    return subtractMonths(years*12);
  }

  DateTime addDay() {
    return addDays();
  }

  DateTime subtractDay() {
    return subtractDays();
  }

  DateTime addDays([int days = 1]) {
    return add(Duration(days: days));
  }

  DateTime subtractDays([int days = 1]) {
    return subtract(Duration(days: days));
  }
}

// extension StringExtension on String {
//   String capitalizeFirstChar() {
//     return isNotEmpty
//         ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
//         : '';
//   }

//   String? get getUrlIfValid => Uri.tryParse(this)?.toString();

//   Future<bool> get isImageUrl async {
//     try {
//       final response = await Dio().head(this);
//       if (response.statusCode == 200) {
//         final contentType = response.headers.value('content-type');
//         return contentType != null && contentType.startsWith('image/');
//       }
//     } catch (e) {
//       debugPrint('Error checking URL: $e');
//     }
//     return false;
//   }
// }

// class Launcher {
//   static void launchCallerTo(String number) async {
//     Uri url = Uri(scheme: "tel", path: number);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   static launchUri(String data) async {
//     final url = Uri.parse(data);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.platformDefault);
//     } else {
//       debugPrint('DebugX: Error - Could not launch $url');
//     }
//   }
// }

extension Substring on String {
  String firstCharOnly() {
    return isNotEmpty ? this[0] : '';
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

extension ListExtension<T> on List<T> {
  /// Checks if all elements in the [other] list are present in this list.
  ///
  /// - Parameters:
  ///   - other: The list of elements to check for within this list.
  /// - Returns: `true` if all elements in [other] are present in this list;
  ///   otherwise, `false`.
  /// 
  /// Usage:
  /// ```dart
  /// List<int> list1 = [1, 2, 3, 4, 5];
  /// List<int> list2 = [2, 3];
  /// List<int> list3 = [6, 7];
  ///
  /// print(list1.containsAll(list2)); // true
  /// print(list1.containsAll(list3)); // false
  /// ```
  bool containsAll(List<T> other) {
    for (T element in other) {
      if (!contains(element)) {
        return false;
      }
    }
    return true;
  }
}
