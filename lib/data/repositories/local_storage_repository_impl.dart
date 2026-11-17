import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDataSource dataSource;

  LocalStorageRepositoryImpl(this.dataSource);

  @override
  Future<MoviePage> getFavoriteMovies({int page = 1, int limit = 20}) {
    return dataSource.getFavoriteMovies(page: page, limit: limit);
  }

  @override
  Future<MoviePage> getWatchlistMovies({int page = 1, int limit = 20}) {
    return dataSource.getWatchlistMovies(page: page, limit: limit);
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    return dataSource.isFavoriteMovie(movieId);
  }

  @override
  Future<bool> isInWatchlistMovie(int movieId) {
    return dataSource.isInWatchlistMovie(movieId);
  }

  @override
  Future<bool> toggleFavoriteMovie(Movie movie) {
    return dataSource.toggleFavoriteMovie(movie);
  }

  @override
  Future<bool> toggleWatchlistMovie(Movie movie) {
    return dataSource.toggleWatchlistMovie(movie);
  }
}
