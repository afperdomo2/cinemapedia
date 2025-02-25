import 'package:cinemapedia/features/movies/data/models/tmdb/movie_details_tmdb_response.dart';
import 'package:cinemapedia/features/movies/data/models/tmdb/movie_tmdb_response.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';

class MovieMapper {
  static const imageBasePath = 'https://image.tmdb.org/t/p/w500';
  static const imageNotFound =
      'https://png.pngtree.com/background/20220729/original/pngtree-glitch-style-poster-with-404-not-found-text-on-screen-with-picture-image_1867996.jpg';

  static _getImagePath(String imagePath) {
    return imagePath != '' ? '$imageBasePath$imagePath' : imageNotFound;
  }

  static Movie movieTMDbResponseToEntity(MovieTMDbResponse movie) {
    return Movie(
      adult: movie.adult,
      backdropPath: _getImagePath(movie.backdropPath),
      genreIds: movie.genreIds.map((e) => e.toString()).toList(),
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: _getImagePath(movie.posterPath),
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
    );
  }

  static Movie movieDetailsTMDbResponseToEntity(MovieDetailsTMDbResponse movie) {
    return Movie(
      adult: movie.adult,
      backdropPath: _getImagePath(movie.backdropPath),
      genreIds: movie.genres.map((e) => e.name).toList(),
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: _getImagePath(movie.posterPath),
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
    );
  }
}
