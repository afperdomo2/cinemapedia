import 'package:cinemapedia/features/movies/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDataSource dataSource;

  LocalStorageRepositoryImpl(this.dataSource);

  @override
  Future<List<Movie>> getFavoriteMovies({int page = 1, int limit = 20}) {
    return dataSource.getFavoriteMovies(page: page, limit: limit);
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    return dataSource.isFavoriteMovie(movieId);
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) {
    return dataSource.toggleFavoriteMovie(movie);
  }
}
