import 'package:cinemapedia/data/models/local/movie_local.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

/// Conversión entre la entidad de dominio [Movie] y su persistencia [MovieLocal].
class MovieLocalMapper {
  static Movie toEntity(MovieLocal local) {
    return Movie(
      adult: local.adult,
      backdropPath: local.backdropPath,
      genreIds: List<String>.from(local.genreIds),
      id: local.id,
      originalLanguage: local.originalLanguage,
      originalTitle: local.originalTitle,
      overview: local.overview,
      popularity: local.popularity,
      posterPath: local.posterPath,
      releaseDate: local.releaseDate,
      title: local.title,
      video: local.video,
      voteAverage: local.voteAverage,
      voteCount: local.voteCount,
    );
  }

  static MovieLocal fromEntity(Movie movie) {
    return MovieLocal(
      id: movie.id,
      adult: movie.adult,
      backdropPath: movie.backdropPath,
      genreIds: List<String>.from(movie.genreIds),
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
