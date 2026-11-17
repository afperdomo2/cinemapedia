import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detalles completos de una película (datos + actores + videos + similares)
/// resueltos en una sola petición y cacheados por id durante la sesión.
///
/// Al ser un `AsyncValue`, la pantalla de detalles renderiza loading / error /
/// datos de forma estructurada, y el error se puede reintentar invalidando el
/// provider correspondiente al id.
final movieDetailsProvider =
    FutureProvider.family<MovieDetails, int>((ref, movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getMovieDetails(movieId);
});
