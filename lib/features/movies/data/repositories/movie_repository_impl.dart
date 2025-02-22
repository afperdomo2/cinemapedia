import 'package:cinemapedia/features/movies/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieDataSource movieDataSource;

  MovieRepositoryImpl(this.movieDataSource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return movieDataSource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return movieDataSource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return movieDataSource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return movieDataSource.getUpcoming(page: page);
  }

  @override
  Future<Movie> getMovieDetails(String id) {
    return movieDataSource.getMovieDetails(id);
  }
}
