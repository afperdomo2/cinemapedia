import 'package:intl/intl.dart';

class HumanFormatter {
  static String largeNumber(double value) {
    return NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'es').format(value);
  }
}
