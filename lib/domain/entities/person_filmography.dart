import 'package:cinemapedia/domain/entities/movie.dart';

/// Crédito de una persona en una película (reparto o equipo).
class PersonCredit {
  const PersonCredit({
    required this.movie,
    this.character,
    this.job,
    this.department = '',
  });

  final Movie movie;

  /// Personaje interpretado (reparto).
  final String? character;

  /// Cargo (equipo: p. ej. 'Director', 'Guionista').
  final String? job;

  /// Departamento (p. ej. 'Acting', 'Directing', 'Writing').
  final String department;
}

/// Filmografía completa de una persona: reparto y equipo.
///
/// Las listas vienen ordenadas por popularidad de la película.
class PersonFilmography {
  const PersonFilmography({required this.cast, required this.crew});

  final List<PersonCredit> cast;
  final List<PersonCredit> crew;

  /// "Conocido por": lo más popular del departamento en el que se destaca la
  /// persona, como en la ficha de TMDB (máximo 4).
  ///
  /// Si el departamento no tiene créditos (o no viene informado), se cae a lo
  /// más popular del reparto.
  List<PersonCredit> knownFor([String? knownForDepartment]) {
    final department = knownForDepartment?.trim() ?? '';
    final isActing = department.isEmpty || department == 'Acting';
    final primary = isActing
        ? cast
        : crew.where((credit) => credit.department == department).toList();

    final source = primary.isNotEmpty ? primary : cast;
    final sorted = source.toList()
      ..sort((a, b) => b.movie.popularity.compareTo(a.movie.popularity));
    return sorted.take(4).toList();
  }

  /// Créditos de dirección (departamento 'Directing').
  List<PersonCredit> get direction =>
      crew.where((credit) => credit.department == 'Directing').toList();

  /// Créditos de equipo que no son dirección.
  List<PersonCredit> get crewOther =>
      crew.where((credit) => credit.department != 'Directing').toList();
}
