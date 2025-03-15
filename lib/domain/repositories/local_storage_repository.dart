import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavoriteMovie(Movie movie);

  Future<bool> isFavoriteMovie(int movieId);

  Future<List<Movie>> getFavoriteMovies({int page = 1, int limit = 20});
}
