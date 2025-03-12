import 'package:cinemapedia/features/movies/domain/entities/movie.dart';

abstract class LocalStorageDataSource {
  Future<void> toggleFavoriteMovie(Movie movie);

  Future<bool> isFavoriteMovie(int movieId);

  Future<List<Movie>> getFavoriteMovies({int page = 1, int limit = 20});
}
