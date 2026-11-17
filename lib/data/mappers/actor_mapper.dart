import 'package:cinemapedia/data/models/tmdb/movie_credits_tmdb_response.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) {
    return Actor(
      id: cast.id,
      name: cast.name,
      // Ruta relativa: el tamaño se resuelve en la capa de presentación.
      profilePath: cast.profilePath ?? '',
      character: cast.character,
    );
  }
}
