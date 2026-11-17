import 'package:cinemapedia/data/models/local/cached_payload_local.dart';
import 'package:cinemapedia/data/models/local/movie_local.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Abre (una única vez) la base Isar con todas las colecciones de la capa de
/// datos y corre las migraciones pendientes.
class IsarDatabase {
  IsarDatabase._();

  static Future<Isar>? _instance;

  static Future<Isar> open() => _instance ??= _open();

  static Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();

    final isar = (Isar.instanceNames.isEmpty)
        ? await Isar.open([MovieLocalSchema, CachedPayloadLocalSchema],
            inspector: true, directory: dir.path)
        : Isar.getInstance()!;

    await _migrateLegacyFavorites(isar);
    return isar;
  }

  /// Filas de versiones anteriores eran favoritas por simple presencia: se
  /// marcan como tales una única vez. Las filas nuevas siempre tienen al
  /// menos una bandera en `true`, así que la migración es idempotente.
  static Future<void> _migrateLegacyFavorites(Isar isar) async {
    final legacy = await isar.movieLocals
        .filter()
        .isFavoriteEqualTo(false)
        .and()
        .inWatchlistEqualTo(false)
        .findAll();

    if (legacy.isEmpty) return;

    await isar.writeTxn(() async {
      for (final movie in legacy) {
        movie.isFavorite = true;
        await isar.movieLocals.put(movie);
      }
    });
  }
}
