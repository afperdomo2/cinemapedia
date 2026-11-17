/// Persona de TMDB (actor, actriz, dirección…).
class Person {
  const Person({
    required this.id,
    required this.name,
    required this.biography,
    required this.profilePath,
    this.birthday,
    this.placeOfBirth,
    this.knownForDepartment,
  });

  final int id;
  final String name;
  final String biography;

  /// Ruta relativa de la foto en TMDB (vacía si no hay imagen).
  final String profilePath;

  final String? birthday;
  final String? placeOfBirth;
  final String? knownForDepartment;
}
