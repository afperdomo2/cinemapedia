import 'package:cinemapedia/common/state/movies_notifier.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/repositories/local_storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Películas de la lista "Quiero ver" paginadas desde el almacenamiento local.
final watchlistMoviesProvider =
    NotifierProvider<WatchlistMoviesNotifier, MoviesState>(
  WatchlistMoviesNotifier.new,
);

/// Consulta puntual de si una película está en "Quiero ver" (no depende de la
/// paginación de la lista).
final isInWatchlistMovieProvider =
    FutureProvider.autoDispose.family<bool, int>((ref, movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isInWatchlistMovie(movieId);
});

class WatchlistMoviesNotifier extends MoviesNotifier {
  WatchlistMoviesNotifier() : super(_selectFetcher);

  static MoviePageFetcher _selectFetcher(Ref ref) {
    return ({int page = 1}) {
      return ref
          .read(localStorageRepositoryProvider)
          .getWatchlistMovies(page: page);
    };
  }

  /// Agrega o quita una película de "Quiero ver" y actualiza la lista en memoria.
  ///
  /// Devuelve `true` si la película quedó en la lista.
  Future<bool> toggleWatchlistMovie(Movie movie) async {
    final inWatchlist = await ref
        .read(localStorageRepositoryProvider)
        .toggleWatchlistMovie(movie);

    final withoutMovie =
        state.movies.where((item) => item.id != movie.id).toList();
    state = state.copyWith(
      movies: inWatchlist ? [movie, ...withoutMovie] : withoutMovie,
    );

    // Mantiene sincronizado el marcador de la pantalla de detalles.
    ref.invalidate(isInWatchlistMovieProvider(movie.id));

    return inWatchlist;
  }
}
