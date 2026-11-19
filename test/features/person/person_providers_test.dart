import 'package:cinemapedia/features/person/providers/person_providers.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeMovieRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakeMovieRepository();
    container = ProviderContainer(
      overrides: [
        movieRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  group('personDetailsProvider', () {
    test('devuelve los datos de la persona', () async {
      final person = await container.read(personDetailsProvider(7).future);

      expect(person.id, 7);
      expect(person.name, 'Persona');
      expect(fakeRepository.calls, contains('person:7'));
    });

    test('expone el error para que la pantalla pueda reintentar', () async {
      fakeRepository.personError = Exception('Sin conexión');

      await expectLater(
        container.read(personDetailsProvider(7).future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('personCreditsProvider', () {
    test('devuelve la filmografía (reparto y equipo)', () async {
      final filmography = await container.read(personCreditsProvider(7).future);

      expect(filmography.cast, hasLength(2));
      expect(filmography.crew, hasLength(2));
      expect(fakeRepository.calls, contains('personCredits:7'));
    });

    test('expone el error para que la pantalla pueda reintentar', () async {
      fakeRepository.personError = Exception('Sin conexión');

      await expectLater(
        container.read(personCreditsProvider(7).future),
        throwsA(isA<Exception>()),
      );
    });
  });
}
