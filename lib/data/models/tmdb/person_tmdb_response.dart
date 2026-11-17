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

class PersonMovieCreditsTMDbResponse {
  final List<MovieTMDbResponse> cast;

  PersonMovieCreditsTMDbResponse({
    required this.cast,
  });

  factory PersonMovieCreditsTMDbResponse.fromJson(Map<String, dynamic> json) =>
      PersonMovieCreditsTMDbResponse(
        cast: List<MovieTMDbResponse>.from(
          (json['cast'] ?? const []).map((x) => MovieTMDbResponse.fromJson(x)),
        ),
      );
}
