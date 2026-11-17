import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/person.dart';

/// Enlaces y textos para compartir películas y personas.
///
/// Se comparte el enlace público de TMDB: funciona en cualquier navegador y,
/// con los deep links configurados, abre directo en Cinemapedia.
class ShareLinks {
  const ShareLinks._();

  static const tmdbBase = 'https://www.themoviedb.org';

  static String movieUrl(int movieId) => '$tmdbBase/movie/$movieId';

  static String personUrl(int personId) => '$tmdbBase/person/$personId';

  static String movieText(Movie movie) {
    final rating = movie.voteAverage.toStringAsFixed(1);
    return '${movie.title} ($rating/10)\n${movieUrl(movie.id)}';
  }

  static String personText(Person person) {
    return '${person.name}\n${personUrl(person.id)}';
  }
}
