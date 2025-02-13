import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/models/tmdb/movie_tmdb_response.dart';

class MovieMapper {
  static const baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  static const notFoundImageUrl =
      'https://png.pngtree.com/background/20220729/original/pngtree-glitch-style-poster-with-404-not-found-text-on-screen-with-picture-image_1867996.jpg';

  static Movie movieTMDbResponseToEntity(MovieTMDbResponse movie) {
    final backdropPath = movie.backdropPath != '' ? '$baseImageUrl${movie.backdropPath}' : notFoundImageUrl;
    final posterPath = movie.posterPath != '' ? '$baseImageUrl${movie.posterPath}' : 'no-poster';

    return Movie(
      adult: movie.adult,
      backdropPath: backdropPath,
      genreIds: movie.genreIds.map((e) => e.toString()).toList(),
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: posterPath,
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
    );
  }
}
