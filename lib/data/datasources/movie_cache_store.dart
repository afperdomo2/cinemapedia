/// Entrada de caché: payload serializado y momento en que se obtuvo.
class CacheEntry {
  const CacheEntry({required this.payload, required this.fetchedAt});

  final String payload;
  final DateTime fetchedAt;
}

/// Almacenamiento de payloads de TMDB para disponer de contenido sin conexión.
///
/// Vive en la capa de datos: el dominio no conoce el caché.
abstract class MovieCacheStore {
  /// Devuelve la entrada cacheada para [key], o `null` si no hay nada.
  Future<CacheEntry?> read(String key);

  /// Guarda (o reemplaza) el payload de [key] con la hora actual.
  Future<void> put(String key, String payload);
}
