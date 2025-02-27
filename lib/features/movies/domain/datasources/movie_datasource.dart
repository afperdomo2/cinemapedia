import 'package:cinemapedia/features/movies/domain/entities/actor.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';

abstract class MovieDataSource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<Movie> getMovieDetails(String movieId);

  Future<List<Actor>> getMovieActors(String movieId);

  Future<List<Movie>> searchMovies(String query, {int page = 1});
}
