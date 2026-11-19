import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  group('knownFor', () {
    test('para actores muestra lo más popular del reparto', () {
      final filmography = makePersonFilmography();

      final known = filmography.knownFor('Acting');

      expect(known, hasLength(2));
      // Ordenado por popularidad de la película: 2 (20) antes que 1 (10).
      expect(known.first.movie.id, 2);
    });

    test('para otros departamentos filtra el equipo por su área', () {
      final filmography = makePersonFilmography();

      final known = filmography.knownFor('Directing');

      expect(known, hasLength(1));
      expect(known.first.job, 'Director');
    });

    test('si el departamento no tiene créditos cae al reparto', () {
      final filmography = makePersonFilmography();

      final known = filmography.knownFor('Sound');

      expect(known, hasLength(2));
    });

    test('sin departamento informado muestra el reparto', () {
      final filmography = makePersonFilmography();

      expect(filmography.knownFor(), hasLength(2));
      expect(filmography.knownFor(''), hasLength(2));
    });
  });

  group('secciones de equipo', () {
    test('direction separa la dirección del resto del equipo', () {
      final filmography = makePersonFilmography();

      expect(filmography.direction.map((credit) => credit.job), ['Director']);
      expect(
        filmography.crewOther.map((credit) => credit.job),
        ['Guionista'],
      );
    });
  });
}
