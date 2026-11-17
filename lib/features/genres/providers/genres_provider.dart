import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Géneros de TMDB para la pantalla "Explorar".
///
/// Se piden una vez y quedan disponibles para toda la sesión; si fallan, la
/// pantalla ofrece reintentar con `ref.invalidate`.
final genresProvider = FutureProvider<List<Genre>>((ref) {
  return ref.watch(movieRepositoryProvider).getGenres();
});
