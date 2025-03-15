import 'package:cinemapedia/data/models/tmdb/movie_credits_tmdb_response.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

class ActorMapper {
  static const imageBasePath = 'https://image.tmdb.org/t/p/w500';
  static const imageNotFound =
      'https://icon-library.com/images/no-profile-picture-icon/no-profile-picture-icon-1.jpg';

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
