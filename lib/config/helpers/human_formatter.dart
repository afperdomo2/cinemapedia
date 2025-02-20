import 'package:intl/intl.dart';

class HumanFormatter {
  static String largeNumber(double value) {
    return NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'es').format(value);
  }

  static String currentDa(DateTime date) {
    String formattedDate = DateFormat('EEEE d', 'es').format(date);
    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }
}
