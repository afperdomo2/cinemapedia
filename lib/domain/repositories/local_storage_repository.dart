import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';

abstract class LocalStorageRepository {
  /// Agrega o quita la película de favoritos.
  ///
  /// Devuelve `true` si después de la operación la película es favorita.
  Future<bool> toggleFavoriteMovie(Movie movie);

  /// Agrega o quita la película de la lista "Quiero ver".
  ///
  /// Devuelve `true` si después de la operación la película está en la lista.
  Future<bool> toggleWatchlistMovie(Movie movie);

  Future<bool> isFavoriteMovie(int movieId);

  Future<bool> isInWatchlistMovie(int movieId);

  Future<MoviePage> getFavoriteMovies({int page = 1, int limit = 20});

  Future<MoviePage> getWatchlistMovies({int page = 1, int limit = 20});
}
