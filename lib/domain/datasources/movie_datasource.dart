import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';

abstract class MovieDataSource {
  Future<MoviePage> getNowPlaying({int page = 1});

  Future<MoviePage> getPopular({int page = 1});

  Future<MoviePage> getTopRated({int page = 1});

  Future<MoviePage> getUpcoming({int page = 1});

  /// Detalles completos de una película: datos, actores, videos y similares.
  Future<MovieDetails> getMovieDetails(int movieId);

  Future<MoviePage> searchMovies(String query, {int page = 1});
}
