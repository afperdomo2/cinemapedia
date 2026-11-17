import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get theMovieDbApiKey {
    final key = dotenv.env['THE_MOVIE_DB_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError(
        'THE_MOVIE_DB_API_KEY no está definida. '
        'Copiá .env.example a .env y cargá tu API key de TMDB.',
      );
    }
    return key;
  }
}
