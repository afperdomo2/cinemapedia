import 'package:cinemapedia/domain/entities/movie.dart';

/// Página de resultados de TMDB junto con su metadata de paginación.
class MoviePage {
  const MoviePage({
    required this.movies,
    required this.page,
    required this.totalPages,
    this.fromCache = false,
  });

  final List<Movie> movies;
  final int page;
  final int totalPages;

  /// `true` si el contenido se sirvió del caché local porque no había red.
  final bool fromCache;

  /// `true` si todavía quedan páginas por pedir.
  bool get hasMore => movies.isNotEmpty && page < totalPages;

  static const empty = MoviePage(movies: [], page: 0, totalPages: 0);
}
