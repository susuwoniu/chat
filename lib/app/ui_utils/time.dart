import 'package:date_format/date_format.dart';

String getTime(DateTime time) {
  final _time = time.millisecondsSinceEpoch;
  final nowDate = DateTime.now();
  final now = nowDate.millisecondsSinceEpoch;
  final diffHours = (now - _time) / 1000 / 60 / 60;
  final year = time.year;
  final nowYear = nowDate.year;
  if (diffHours < 24) {
    return formatDate(time, [HH, ':', nn]);
  } else if (year == nowYear) {
    return formatDate(time, [mm, '-', dd]);
  } else {
    return formatDate(time, [yy, '-', mm, '-', dd]);
  }
}
