import 'package:cinemapedia/data/mappers/movie_mapper.dart';
import 'package:cinemapedia/data/models/tmdb/person_tmdb_response.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';

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

  static PersonCredit creditTMDbResponseToEntity(
      PersonCreditTMDbResponse credit) {
    return PersonCredit(
      movie: MovieMapper.movieTMDbResponseToEntity(credit.movie),
      character: credit.character,
      job: credit.job,
      department: credit.department,
    );
  }

  static PersonFilmography movieCreditsTMDbResponseToEntity(
      PersonMovieCreditsTMDbResponse credits) {
    return PersonFilmography(
      cast: _byPopularity(credits.cast.map(creditTMDbResponseToEntity)),
      crew: _byPopularity(credits.crew.map(creditTMDbResponseToEntity)),
    );
  }

  /// TMDB no garantiza orden: lo más popular primero.
  static List<PersonCredit> _byPopularity(Iterable<PersonCredit> credits) {
    return credits.toList()
      ..sort((a, b) => b.movie.popularity.compareTo(a.movie.popularity));
  }
}
