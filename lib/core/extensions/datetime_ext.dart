import '../constants.dart';

extension DateTimeKalorie on DateTime {
  int get dateKey => DateKeys.fromDateTime(this);

  DateTime get atMidnight => DateTime(year, month, day);
}
