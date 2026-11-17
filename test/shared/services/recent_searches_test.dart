import 'package:cinemapedia/shared/services/recent_searches.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('guarda y devuelve las búsquedas recientes', () async {
    SharedPreferences.setMockInitialValues({});
    final recentSearches = await RecentSearches.load();

    await recentSearches.add('Matrix');
    await recentSearches.add('Interestelar');

    expect(recentSearches.all, ['Interestelar', 'Matrix']);
  });

  test('no repite consultas (ignorando mayúsculas) y descarta vacías',
      () async {
    SharedPreferences.setMockInitialValues({});
    final recentSearches = await RecentSearches.load();

    await recentSearches.add('matrix');
    await recentSearches.add('MATRIX');
    await recentSearches.add('   ');

    expect(recentSearches.all, ['MATRIX']);
  });

  test('conserva solo las últimas ocho búsquedas', () async {
    SharedPreferences.setMockInitialValues({});
    final recentSearches = await RecentSearches.load();

    for (var i = 1; i <= 10; i++) {
      await recentSearches.add('Película $i');
    }

    expect(recentSearches.all, hasLength(8));
    expect(recentSearches.all.first, 'Película 10');
    expect(recentSearches.all, isNot(contains('Película 1')));
  });

  test('clear elimina el historial', () async {
    SharedPreferences.setMockInitialValues({});
    final recentSearches = await RecentSearches.load();

    await recentSearches.add('Matrix');
    await recentSearches.clear();

    expect(recentSearches.all, isEmpty);
  });
}
