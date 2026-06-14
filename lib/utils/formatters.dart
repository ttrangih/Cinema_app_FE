// lib/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  static String currency(num amount) {
    final formatted = NumberFormat('#,###', 'vi_VN').format(amount);
    return '${formatted.replaceAll(',', '.')}đ';
  }

  static String timeVN(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  static String dateTimeVN(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();

    return '$hour:$minute - $day/$month/$year';
  }

  static String dateVN(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();

    return '$day/$month/$year';
  }



  static String dateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String duration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}p';
    if (m == 0) return '${h}h';
    return '${h}h${m}p';
  }

  static String countdown(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
