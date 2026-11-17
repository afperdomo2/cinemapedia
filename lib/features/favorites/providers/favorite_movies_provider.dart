import 'package:cinemapedia/common/state/movies_notifier.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/repositories/local_storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Películas favoritas paginadas desde el almacenamiento local.
final favoriteMoviesProvider =
    NotifierProvider<FavoriteMoviesNotifier, MoviesState>(
  FavoriteMoviesNotifier.new,
);

/// Consulta puntual de si una película es favorita (no depende de la
/// paginación de la lista).
final isFavoriteMovieProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isFavoriteMovie(movieId);
});

class FavoriteMoviesNotifier extends MoviesNotifier {
  FavoriteMoviesNotifier() : super(_selectFetcher);

  static MoviePageFetcher _selectFetcher(Ref ref) {
    return ({int page = 1}) {
      return ref
          .read(localStorageRepositoryProvider)
          .getFavoriteMovies(page: page);
    };
  }

  /// Agrega o quita una película de favoritos y actualiza la lista en memoria.
  ///
  /// Devuelve `true` si la película quedó como favorita.
  Future<bool> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await ref
        .read(localStorageRepositoryProvider)
        .toggleFavoriteMovie(movie);

    final withoutMovie =
        state.movies.where((item) => item.id != movie.id).toList();
    state = state.copyWith(
      movies: isFavorite ? [movie, ...withoutMovie] : withoutMovie,
    );

    // Mantiene sincronizado el corazón de la pantalla de detalles.
    ref.invalidate(isFavoriteMovieProvider(movie.id));

    return isFavorite;
  }
}
