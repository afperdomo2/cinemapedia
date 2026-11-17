import 'package:cinemapedia/data/datasources/isar_database.dart';
import 'package:cinemapedia/data/datasources/movie_cache_store.dart';
import 'package:cinemapedia/data/models/local/cached_payload_local.dart';
import 'package:isar/isar.dart';

/// Caché de payloads sobre la base Isar de la app.
class IsarMovieCacheStore implements MovieCacheStore {
  IsarMovieCacheStore({this.maxAge = const Duration(days: 30)});

  /// Las entradas más viejas se purgan: solo sirven como respaldo offline.
  final Duration maxAge;

  Future<Isar> get db => IsarDatabase.open();

  @override
  Future<CacheEntry?> read(String key) async {
    final isar = await db;
    final local =
        await isar.cachedPayloadLocals.where().keyEqualTo(key).findFirst();
    return (local == null)
        ? null
        : CacheEntry(payload: local.payload, fetchedAt: local.fetchedAt);
  }

  @override
  Future<void> put(String key, String payload) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cachedPayloadLocals.put(
        CachedPayloadLocal(
          key: key,
          payload: payload,
          fetchedAt: DateTime.now(),
        ),
      );
    });
    await _prune(isar);
  }

  Future<void> _prune(Isar isar) async {
    final cutoff = DateTime.now().subtract(maxAge);
    final old = await isar.cachedPayloadLocals
        .filter()
        .fetchedAtLessThan(cutoff)
        .findAll();

    if (old.isEmpty) return;

    await isar.writeTxn(() async {
      await isar.cachedPayloadLocals
          .deleteAll(old.map((entry) => entry.isarId).toList());
    });
  }
}
