import 'package:cinemapedia/data/repositories/local_storage_repository_impl.dart';
import 'package:cinemapedia/features/favorites/providers/watchlist_movies_provider.dart';
import 'package:cinemapedia/providers/repositories/local_storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeLocalStorageDataSource fakeDataSource;
  late ProviderContainer container;

  setUp(() {
    fakeDataSource = FakeLocalStorageDataSource();
    container = ProviderContainer(
      overrides: [
        localStorageRepositoryProvider.overrideWithValue(
          LocalStorageRepositoryImpl(fakeDataSource),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('toggleWatchlistMovie agrega y quita de "Quiero ver"', () async {
    final notifier = container.read(watchlistMoviesProvider.notifier);
    final movie = makeMovie(id: 10, title: 'Por ver');

    final added = await notifier.toggleWatchlistMovie(movie);
    expect(added, isTrue);
    expect(container.read(watchlistMoviesProvider).movies, hasLength(1));
    expect(fakeDataSource.watchlist.containsKey(10), isTrue);

    final removed = await notifier.toggleWatchlistMovie(movie);
    expect(removed, isFalse);
    expect(container.read(watchlistMoviesProvider).movies, isEmpty);
    expect(fakeDataSource.watchlist.containsKey(10), isFalse);
  });

  test('una película puede estar en favoritos y en "Quiero ver" a la vez',
      () async {
    final movie = makeMovie(id: 5);
    await container
        .read(watchlistMoviesProvider.notifier)
        .toggleWatchlistMovie(movie);
    await fakeDataSource.toggleFavoriteMovie(movie);

    expect(fakeDataSource.watchlist.containsKey(5), isTrue);
    expect(fakeDataSource.favorites.containsKey(5), isTrue);
  });

  test('al agregar, la película aparece primero en la lista', () async {
    final notifier = container.read(watchlistMoviesProvider.notifier);
    await notifier.toggleWatchlistMovie(makeMovie(id: 1));
    await notifier.toggleWatchlistMovie(makeMovie(id: 2));

    final movies = container.read(watchlistMoviesProvider).movies;
    expect(movies.first.id, 2);
  });

  test('loadNextPage pagina desde el almacenamiento local', () async {
    for (var id = 1; id <= 3; id++) {
      await container
          .read(watchlistMoviesProvider.notifier)
          .toggleWatchlistMovie(makeMovie(id: id));
    }

    final notifier = container.read(watchlistMoviesProvider.notifier);
    await notifier.loadNextPage();

    final state = container.read(watchlistMoviesProvider);
    expect(state.movies, hasLength(3));
    expect(state.hasMore, isFalse);
  });

  test('quitar una película no cargada no la agrega a la lista', () async {
    // La película está en "Quiero ver" pero no en la primera página cargada.
    fakeDataSource.watchlist[77] = makeMovie(id: 77);
    fakeDataSource.watchlist[78] = makeMovie(id: 78);
    fakeDataSource.watchlist[79] = makeMovie(id: 79);

    final notifier = container.read(watchlistMoviesProvider.notifier);
    await notifier.loadNextPage();
    expect(container.read(watchlistMoviesProvider).movies, hasLength(3));

    // Se quita desde la pantalla de detalles (estado ya cargado en lista).
    await notifier.toggleWatchlistMovie(makeMovie(id: 79));
    final state = container.read(watchlistMoviesProvider);
    expect(state.movies.map((movie) => movie.id), isNot(contains(79)));
    expect(fakeDataSource.watchlist.containsKey(79), isFalse);
  });
}
