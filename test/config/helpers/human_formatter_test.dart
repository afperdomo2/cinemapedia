import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es', null));

  test('largeNumber abrevia números grandes', () {
    expect(HumanFormatter.largeNumber(0), '0');
    expect(HumanFormatter.largeNumber(123), '123');
    expect(HumanFormatter.largeNumber(1500), contains('mil'));
  });

  test('currentDate capitaliza el día de la semana', () {
    final formatted = HumanFormatter.currentDate(DateTime(2026, 11, 17));

    expect(formatted, 'Martes 17');
  });

  test('shortDate usa el formato abreviado en español', () {
    final formatted = HumanFormatter.shortDate(DateTime(2026, 11, 17));

    expect(formatted.toLowerCase(), contains('2026'));
    expect(formatted.toLowerCase(), contains('mar'));
  });
}
