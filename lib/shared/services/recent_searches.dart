import 'package:shared_preferences/shared_preferences.dart';

/// Historial local de búsquedas recientes del usuario.
class RecentSearches {
  RecentSearches(this._preferences);

  static const _key = 'recent_searches';
  static const _maxEntries = 8;

  final SharedPreferences _preferences;

  static Future<RecentSearches> load() async {
    return RecentSearches(await SharedPreferences.getInstance());
  }

  List<String> get all => _preferences.getStringList(_key) ?? const [];

  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final searches = [
      trimmed,
      ...all.where((search) => search.toLowerCase() != trimmed.toLowerCase()),
    ].take(_maxEntries).toList();

    await _preferences.setStringList(_key, searches);
  }

  Future<void> clear() => _preferences.remove(_key);
}
