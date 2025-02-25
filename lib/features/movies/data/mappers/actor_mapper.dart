import 'package:cinemapedia/features/movies/data/models/tmdb/movie_credits_tmdb_response.dart';
import 'package:cinemapedia/features/movies/domain/entities/actor.dart';

class ActorMapper {
  static const imageBasePath = 'https://image.tmdb.org/t/p/w500';
  static const imageNotFound =
      'https://png.pngtree.com/background/20220729/original/pngtree-glitch-style-poster-with-404-not-found-text-on-screen-with-picture-image_1867996.jpg';

  static _getImagePath(String imagePath) {
    return imagePath != '' ? '$imageBasePath$imagePath' : imageNotFound;
  }

  static Actor castToEntity(Cast cast) {
    return Actor(
      id: cast.id,
      name: cast.name,
      profilePath: _getImagePath(cast.profilePath ?? ''),
      character: cast.character,
    );
  }
}
