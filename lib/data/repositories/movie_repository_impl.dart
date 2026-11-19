import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/genre_filter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieDataSource movieDataSource;

  MovieRepositoryImpl(this.movieDataSource);

  @override
  Future<MoviePage> getNowPlaying({int page = 1}) {
    return movieDataSource.getNowPlaying(page: page);
  }

  @override
  Future<MoviePage> getPopular({int page = 1}) {
    return movieDataSource.getPopular(page: page);
  }

  @override
  Future<MoviePage> getTopRated({int page = 1}) {
    return movieDataSource.getTopRated(page: page);
  }

  @override
  Future<MoviePage> getUpcoming({int page = 1}) {
    return movieDataSource.getUpcoming(page: page);
  }

  @override
  Future<MovieDetails> getMovieDetails(int movieId) {
    return movieDataSource.getMovieDetails(movieId);
  }

  @override
  Future<MoviePage> searchMovies(String query, {int page = 1}) {
    return movieDataSource.searchMovies(query, page: page);
  }

  @override
  Future<List<Genre>> getGenres() {
    return movieDataSource.getGenres();
  }

  @override
  Future<MoviePage> discoverMovies(GenreFilter filter, {int page = 1}) {
    return movieDataSource.discoverMovies(filter, page: page);
  }

  @override
  Future<Movie> getRandomMovie({int? genreId, double? minVoteAverage}) {
    return movieDataSource.getRandomMovie(
      genreId: genreId,
      minVoteAverage: minVoteAverage,
    );
  }

  @override
  Future<Person> getPerson(int personId) {
    return movieDataSource.getPerson(personId);
  }

  @override
  Future<PersonFilmography> getPersonMovieCredits(int personId) {
    return movieDataSource.getPersonMovieCredits(personId);
  }
}
