import 'package:cinemapedia/data/models/tmdb/person_tmdb_response.dart';
import 'package:cinemapedia/domain/entities/person.dart';

class PersonMapper {
  static Person personTMDbResponseToEntity(PersonTMDbResponse person) {
    return Person(
      id: person.id,
      name: person.name,
      biography: person.biography,
      // Ruta relativa: el tamaño se resuelve en la capa de presentación.
      profilePath: person.profilePath,
      birthday: person.birthday,
      placeOfBirth: person.placeOfBirth,
      knownForDepartment: person.knownForDepartment,
    );
  }
}
