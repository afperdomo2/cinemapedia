import 'package:isar/isar.dart';

part 'movie_local.g.dart';

/// Persistencia local de favoritos (Isar).
///
/// Vive en la capa de datos: el dominio no conoce Isar. El [id] de TMDB lleva
/// índice único para que las consultas de favorito no recorran toda la
/// colección.
@Collection()
class MovieLocal {
  MovieLocal({
    required this.id,
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  Id isarId = Isar.autoIncrement;

  /// Id de TMDB (clave de negocio de la película).
  @Index(unique: true, replace: true)
  final int id;

  final bool adult;
  final String backdropPath;
  final List<String> genreIds;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime? releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
}
