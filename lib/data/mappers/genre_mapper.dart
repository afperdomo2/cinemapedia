import 'package:cinemapedia/data/models/tmdb/genre_list_tmdb_response.dart';
import 'package:cinemapedia/domain/entities/genre.dart';

class GenreMapper {
  static Genre genreTMDbResponseToEntity(GenreTMDbResponse genre) {
    return Genre(id: genre.id, name: genre.name);
  }
}
