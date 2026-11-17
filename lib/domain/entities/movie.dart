/// Película de TMDB.
///
/// Entidad pura de dominio: no depende de Isar ni de la API.
/// Las rutas de imagen se guardan relativas (p. ej. `/abc.jpg`) y el tamaño
/// final se resuelve en la capa de presentación según el uso.
class Movie {
  const Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
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

  final bool adult;

  /// Ruta relativa del backdrop en TMDB (vacía si no hay imagen).
  final String backdropPath;

  final List<String> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;

  /// Ruta relativa del poster en TMDB (vacía si no hay imagen).
  final String posterPath;

  final DateTime? releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
}
