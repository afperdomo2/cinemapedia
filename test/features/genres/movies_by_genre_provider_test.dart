import 'package:cinemapedia/features/genres/providers/genres_provider.dart';
import 'package:cinemapedia/features/genres/providers/movies_by_genre_provider.dart';
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

  group('genresProvider', () {
    test('devuelve los géneros de TMDB', () async {
      final genres = await container.read(genresProvider.future);

      expect(genres.map((genre) => genre.name), ['Acción', 'Comedia']);
      expect(fakeRepository.calls, contains('genres'));
    });

    test('expone el error para que la pantalla pueda reintentar', () async {
      fakeRepository.genresError = Exception('Sin conexión');

      await expectLater(
        container.read(genresProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('moviesByGenreProvider', () {
    test('carga la primera página del género', () async {
      final notifier = container.read(moviesByGenreProvider(28).notifier);
      await notifier.loadNextPage();

      final state = container.read(moviesByGenreProvider(28));
      expect(state.movies, hasLength(3));
      expect(state.isLoading, isFalse);
      expect(fakeRepository.calls, contains('discover:28:1'));
    });

    test('pagina con infinite scroll hasta agotar el género', () async {
      final notifier = container.read(moviesByGenreProvider(28).notifier);
      await notifier.loadNextPage();
      await notifier.loadNextPage();
      await notifier.loadNextPage();

      final state = container.read(moviesByGenreProvider(28));
      expect(state.movies, hasLength(9));
      expect(state.hasMore, isFalse);
    });

    test('cada género tiene su paginación independiente', () async {
      await container.read(moviesByGenreProvider(28).notifier).loadNextPage();
      await container.read(moviesByGenreProvider(35).notifier).loadNextPage();
      await container.read(moviesByGenreProvider(35).notifier).loadNextPage();

      expect(container.read(moviesByGenreProvider(28)).movies, hasLength(3));
      expect(container.read(moviesByGenreProvider(35)).movies, hasLength(6));
    });

    test('un error sin contenido muestra el mensaje de dominio', () async {
      fakeRepository.pageError = Exception('Sin conexión');

      final notifier = container.read(moviesByGenreProvider(28).notifier);
      await notifier.loadNextPage();

      final state = container.read(moviesByGenreProvider(28));
      expect(state.hasError, isTrue);
      expect(state.errorMessage, isNotEmpty);
    });
  });
}
