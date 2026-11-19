import 'package:cinemapedia/domain/entities/genre_filter.dart';
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

  group('GenreFilter', () {
    test('dos filtros iguales son la misma clave', () {
      expect(
        const GenreFilter(genreId: 28),
        const GenreFilter(genreId: 28),
      );
      expect(
        const GenreFilter(genreId: 28, releaseYear: 2024).hashCode,
        const GenreFilter(genreId: 28, releaseYear: 2024).hashCode,
      );
    });

    test('filtros distintos no se confunden', () {
      expect(
        const GenreFilter(genreId: 28, sortBy: MovieSort.recientes),
        isNot(const GenreFilter(genreId: 28)),
      );
      expect(
        const GenreFilter(genreId: 28, releaseYear: 2024),
        isNot(const GenreFilter(genreId: 28, releaseYear: 2025)),
      );
    });

    test('mapea los parámetros que espera TMDB', () {
      const filter = GenreFilter(
        genreId: 28,
        sortBy: MovieSort.mejorValoradas,
        releaseYear: 2024,
      );

      expect(filter.queryParameters, {
        'with_genres': 28,
        'sort_by': 'vote_average.desc',
        'vote_count.gte': 50,
        'primary_release_year': 2024,
      });
    });
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
    const filter = GenreFilter(genreId: 28);

    test('carga la primera página del género', () async {
      final notifier = container.read(moviesByGenreProvider(filter).notifier);
      await notifier.loadNextPage();

      final state = container.read(moviesByGenreProvider(filter));
      expect(state.movies, hasLength(3));
      expect(state.isLoading, isFalse);
      expect(fakeRepository.calls, contains('discover:28:populares:null:1'));
    });

    test('pagina con infinite scroll hasta agotar el género', () async {
      final notifier = container.read(moviesByGenreProvider(filter).notifier);
      await notifier.loadNextPage();
      await notifier.loadNextPage();
      await notifier.loadNextPage();

      final state = container.read(moviesByGenreProvider(filter));
      expect(state.movies, hasLength(9));
      expect(state.hasMore, isFalse);
    });

    test('cada filtro tiene su paginación independiente', () async {
      const other = GenreFilter(genreId: 28, sortBy: MovieSort.recientes);

      await container
          .read(moviesByGenreProvider(filter).notifier)
          .loadNextPage();
      await container
          .read(moviesByGenreProvider(other).notifier)
          .loadNextPage();
      await container
          .read(moviesByGenreProvider(other).notifier)
          .loadNextPage();

      expect(
          container.read(moviesByGenreProvider(filter)).movies, hasLength(3));
      expect(container.read(moviesByGenreProvider(other)).movies, hasLength(6));
    });

    test('un error sin contenido muestra el mensaje de dominio', () async {
      fakeRepository.pageError = Exception('Sin conexión');

      final notifier = container.read(moviesByGenreProvider(filter).notifier);
      await notifier.loadNextPage();

      final state = container.read(moviesByGenreProvider(filter));
      expect(state.hasError, isTrue);
      expect(state.errorMessage, isNotEmpty);
    });
  });
}
