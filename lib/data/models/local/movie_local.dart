import 'package:isar/isar.dart';

part 'movie_local.g.dart';

/// Persistencia local de las listas del usuario (Isar): favoritas y "quiero ver".
///
/// Vive en la capa de datos: el dominio no conoce Isar. El [id] de TMDB lleva
/// índice único para que las consultas no recorran toda la colección.
///
/// Una fila existe si la película está en al menos una lista; las banderas
/// [isFavorite] e [inWatchlist] dicen en cuáles. Si ambas quedan en `false`
/// la fila se elimina (nunca se persisten filas sin lista).
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
    this.isFavorite = false,
    this.inWatchlist = false,
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

  /// La película está marcada como favorita.
  ///
  /// Campo mutable: los toggles actualizan la fila existente para conservar
  /// el orden de inserción ([isarId]) en las listas.
  bool isFavorite;

  /// La película está en la lista "Quiero ver".
  bool inWatchlist;
}
