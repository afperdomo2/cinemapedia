import 'package:isar/isar.dart';

part 'cached_payload_local.g.dart';

/// Payload cacheado de TMDB (listas, detalles, búsquedas) para poder mostrar
/// contenido cuando no hay conexión.
///
/// La [key] identifica la consulta (p. ej. `now_playing:1`, `details:123`,
/// `search:batman:1`) y el índice único con `replace` la actualiza en sitio.
@Collection()
class CachedPayloadLocal {
  CachedPayloadLocal({
    required this.key,
    required this.payload,
    required this.fetchedAt,
  });

  Id isarId = Isar.autoIncrement;

  /// Clave de la consulta cacheada.
  @Index(unique: true, replace: true)
  final String key;

  /// Entidades serializadas como JSON (ver `MovieCacheCodec`).
  final String payload;

  /// Momento en que se obtuvo el contenido de TMDB.
  final DateTime fetchedAt;
}
