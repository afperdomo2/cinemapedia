import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/person.dart';

abstract class MovieDataSource {
  Future<MoviePage> getNowPlaying({int page = 1});

  Future<MoviePage> getPopular({int page = 1});

  Future<MoviePage> getTopRated({int page = 1});

  Future<MoviePage> getUpcoming({int page = 1});

  /// Detalles completos de una película: datos, actores, videos y similares.
  Future<MovieDetails> getMovieDetails(int movieId);

  Future<MoviePage> searchMovies(String query, {int page = 1});

  /// Géneros de cine disponibles en TMDB.
  Future<List<Genre>> getGenres();

  /// Películas de un género, ordenadas por popularidad (como `discover`).
  Future<MoviePage> discoverMoviesByGenre(int genreId, {int page = 1});

  /// Datos públicos de una persona (actor, dirección…).
  Future<Person> getPerson(int personId);

  /// Filmografía de una persona (como reparto), ordenada por popularidad.
  Future<List<Movie>> getPersonMovieCredits(int personId);
}
