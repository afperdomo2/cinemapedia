import 'package:cinemapedia/features/movies/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';

class IsarDatasource extends LocalStorageDataSource {
  @override
  Future<List<Movie>> getFavoriteMovies({int page = 1}) {
    // TODO: implement getFavoriteMovies
    throw UnimplementedError();
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    // TODO: implement isFavoriteMovie
    throw UnimplementedError();
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) {
    // TODO: implement toggleFavoriteMovie
    throw UnimplementedError();
  }
}
