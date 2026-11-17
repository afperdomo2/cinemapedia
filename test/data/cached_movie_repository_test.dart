import 'package:cinemapedia/data/datasources/movie_cache_store.dart';
import 'package:cinemapedia/data/repositories/cached_movie_repository.dart';
import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

/// Caché falso en memoria.
class FakeMovieCacheStore implements MovieCacheStore {
  final Map<String, CacheEntry> entries = {};

  @override
  Future<CacheEntry?> read(String key) async => entries[key];

  @override
  Future<void> put(String key, String payload) async {
    entries[key] = CacheEntry(payload: payload, fetchedAt: DateTime.now());
  }
}

void main() {
  late FakeMovieRepository inner;
  late FakeMovieCacheStore cache;
  late CachedMovieRepository repository;

  setUp(() {
    inner = FakeMovieRepository();
    cache = FakeMovieCacheStore();
    repository = CachedMovieRepository(inner, cache);
  });

  group('con red', () {
    test('devuelve la página de TMDB y la cachea', () async {
      final page = await repository.getNowPlaying(page: 1);

      expect(page.movies, hasLength(3));
      expect(page.fromCache, isFalse);
      expect(cache.entries, contains('now_playing:1'));
    });

    test('cada lista usa su propia clave de caché', () async {
      await repository.getPopular(page: 2);
      await repository.getTopRated(page: 2);

      expect(cache.entries.keys, containsAll(['popular:2', 'top_rated:2']));
    });

    test('cacha los detalles de una película', () async {
      await repository.getMovieDetails(42);

      expect(cache.entries, contains('details:42'));
    });
  });

  group('sin red', () {
    test('sirve la última página cacheada y la marca como del caché', () async {
      await repository.getNowPlaying(page: 1);

      inner.pageError = const FetchException('Sin conexión');
      final page = await repository.getNowPlaying(page: 1);

      expect(page.fromCache, isTrue);
      expect(page.movies, hasLength(3));
    });

    test('sirve los detalles cacheados', () async {
      await repository.getMovieDetails(42);

      inner.detailsError = const FetchException('Sin conexión');
      final details = await repository.getMovieDetails(42);

      expect(details.movie.id, 42);
    });

    test('propaga el error si no hay nada cacheado', () async {
      inner.pageError = const FetchException('Sin conexión');
      inner.detailsError = const FetchException('Sin conexión');

      await expectLater(
        repository.getNowPlaying(page: 1),
        throwsA(isA<FetchException>()),
      );
      await expectLater(
        repository.getMovieDetails(42),
        throwsA(isA<FetchException>()),
      );
    });

    test('decodifica correctamente el formato persistido', () async {
      // Roundtrip real: lo que se cachea se puede volver a leer.
      await repository.getNowPlaying(page: 1);
      inner.pageError = const FetchException('Sin conexión');

      final page = await repository.getNowPlaying(page: 1);
      expect(page.page, 1);
      expect(page.totalPages, 3);
      expect(page.hasMore, isTrue);
      expect(page.movies.first.id, isNonZero);
    });
  });

  test('cacha géneros y películas por género', () async {
    await repository.getGenres();
    await repository.discoverMoviesByGenre(28, page: 1);

    expect(cache.entries.keys, containsAll(['genres', 'discover:28:1']));
  });

  test('sin red sirve los géneros cacheados', () async {
    await repository.getGenres();

    inner.genresError = const FetchException('Sin conexión');
    final genres = await repository.getGenres();

    expect(genres, hasLength(2));
  });

  test('cacha personas y su filmografía', () async {
    await repository.getPerson(7);
    await repository.getPersonMovieCredits(7);

    expect(cache.entries.keys, containsAll(['person:7', 'person_credits:7']));
  });

  test('sin red sirve la persona y filmografía cacheadas', () async {
    await repository.getPerson(7);
    await repository.getPersonMovieCredits(7);

    inner.personError = const FetchException('Sin conexión');
    final person = await repository.getPerson(7);
    final credits = await repository.getPersonMovieCredits(7);

    expect(person.name, 'Persona');
    expect(credits, hasLength(2));
  });

  test('las búsquedas se cachean por texto normalizado', () async {
    await repository.searchMovies('Batman');
    await repository.searchMovies('  batman  ');

    expect(
      cache.entries.keys.where((key) => key.startsWith('search:')),
      hasLength(1),
    );
  });
}
