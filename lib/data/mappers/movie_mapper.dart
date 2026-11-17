import 'package:cinemapedia/data/models/tmdb/movie_details_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/movie_tmdb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MovieMapper {
  static Movie movieTMDbResponseToEntity(MovieTMDbResponse movie) {
    return Movie(
      adult: movie.adult,
      backdropPath: movie.backdropPath,
      genreIds: movie.genreIds.map((e) => e.toString()).toList(),
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
    );
  }

  static Movie movieDetailsTMDbResponseToEntity(
      MovieDetailsTMDbResponse movie) {
    return Movie(
      adult: movie.adult,
      backdropPath: movie.backdropPath,
      genreIds: movie.genres.map((e) => e.name).toList(),
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
    );
  }
}
