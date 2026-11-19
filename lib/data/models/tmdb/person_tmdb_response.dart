import 'package:cinemapedia/data/models/tmdb/movie_tmdb_response.dart';

class PersonTMDbResponse {
  final int id;
  final String name;
  final String biography;
  final String? birthday;
  final String? placeOfBirth;
  final String profilePath;
  final String knownForDepartment;

  PersonTMDbResponse({
    required this.id,
    required this.name,
    required this.biography,
    required this.birthday,
    required this.placeOfBirth,
    required this.profilePath,
    required this.knownForDepartment,
  });

  factory PersonTMDbResponse.fromJson(Map<String, dynamic> json) =>
      PersonTMDbResponse(
        id: json['id'],
        name: json['name'] ?? '',
        biography: json['biography'] ?? '',
        birthday: json['birthday'],
        placeOfBirth: json['place_of_birth'],
        profilePath: json['profile_path'] ?? '',
        knownForDepartment: json['known_for_department'] ?? '',
      );
}

/// Crédito de `person/{id}/movie_credits`: película + personaje/cargo.
class PersonCreditTMDbResponse {
  final MovieTMDbResponse movie;
  final String? character;
  final String? job;
  final String department;

  PersonCreditTMDbResponse({
    required this.movie,
    required this.character,
    required this.job,
    required this.department,
  });

  factory PersonCreditTMDbResponse.fromJson(Map<String, dynamic> json) =>
      PersonCreditTMDbResponse(
        movie: MovieTMDbResponse.fromJson(json),
        character: json['character'],
        job: json['job'],
        department: json['department'] ?? '',
      );
}

class PersonMovieCreditsTMDbResponse {
  final List<PersonCreditTMDbResponse> cast;
  final List<PersonCreditTMDbResponse> crew;

  PersonMovieCreditsTMDbResponse({
    required this.cast,
    required this.crew,
  });

  factory PersonMovieCreditsTMDbResponse.fromJson(Map<String, dynamic> json) =>
      PersonMovieCreditsTMDbResponse(
        cast: List<PersonCreditTMDbResponse>.from(
          (json['cast'] ?? const [])
              .map((x) => PersonCreditTMDbResponse.fromJson(x)),
        ),
        crew: List<PersonCreditTMDbResponse>.from(
          (json['crew'] ?? const [])
              .map((x) => PersonCreditTMDbResponse.fromJson(x)),
        ),
      );
}
