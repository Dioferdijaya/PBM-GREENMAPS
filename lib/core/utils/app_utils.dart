import 'package:intl/intl.dart';

class AppUtils {
  static String formatPoints(int points) {
    return NumberFormat('#,###', 'id_ID').format(points).replaceAll(',', '.');
  }

  static String formatWeight(double kg) {
    if (kg < 1) return '${(kg * 1000).toStringAsFixed(0)} gr';
    return '${kg.toStringAsFixed(1)} Kg';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  static String formatCurrency(int amount) {
    return 'Rp ${NumberFormat('#,###', 'id_ID').format(amount).replaceAll(',', '.')}';
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 30) return DateFormat('dd MMM yyyy').format(date);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}
