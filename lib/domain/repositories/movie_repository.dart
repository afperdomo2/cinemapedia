import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/genre_filter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';

abstract class MovieRepository {
  Future<MoviePage> getNowPlaying({int page = 1});

  Future<MoviePage> getPopular({int page = 1});

  Future<MoviePage> getTopRated({int page = 1});

  Future<MoviePage> getUpcoming({int page = 1});

  /// Detalles completos de una película: datos, actores, videos y similares.
  Future<MovieDetails> getMovieDetails(int movieId);

  Future<MoviePage> searchMovies(String query, {int page = 1});

  /// Géneros de cine disponibles en TMDB.
  Future<List<Genre>> getGenres();

  /// Películas que coinciden con el filtro (género, orden y año).
  Future<MoviePage> discoverMovies(GenreFilter filter, {int page = 1});

  /// Una sugerencia al azar, opcionalmente filtrada por género y nota mínima.
  Future<Movie> getRandomMovie({int? genreId, double? minVoteAverage});

  /// Datos públicos de una persona (actor, dirección…).
  Future<Person> getPerson(int personId);

  /// Filmografía completa de una persona: reparto y equipo.
  Future<PersonFilmography> getPersonMovieCredits(int personId);
}
