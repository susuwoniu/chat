import 'package:date_format/date_format.dart';

String getTime(DateTime time) {
  final nowDate = DateTime.now();
  final year = time.year;
  final nowYear = nowDate.year;
  final day = formatDate(time, [yyyy, '-', mm, '-', dd]);
  final nowDay = formatDate(nowDate, [yyyy, '-', mm, '-', dd]);
  if (day == nowDay) {
    return formatDate(time, [HH, ':', nn]);
  } else if (year == nowYear) {
    return formatDate(time, [mm, '/', dd]);
  } else {
    return formatDate(time, [mm, '/', dd, '/', yy]);
  }
}
