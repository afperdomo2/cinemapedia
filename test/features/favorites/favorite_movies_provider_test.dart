import 'package:cinemapedia/data/repositories/local_storage_repository_impl.dart';
import 'package:cinemapedia/features/favorites/providers/favorite_movies_provider.dart';
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

  test('toggleFavoriteMovie agrega y quita de favoritos', () async {
    final notifier = container.read(favoriteMoviesProvider.notifier);
    final movie = makeMovie(id: 10, title: 'Favorita');

    final added = await notifier.toggleFavoriteMovie(movie);
    expect(added, isTrue);
    expect(container.read(favoriteMoviesProvider).movies, hasLength(1));
    expect(fakeDataSource.favorites.containsKey(10), isTrue);

    final removed = await notifier.toggleFavoriteMovie(movie);
    expect(removed, isFalse);
    expect(container.read(favoriteMoviesProvider).movies, isEmpty);
    expect(fakeDataSource.favorites.containsKey(10), isFalse);
  });

  test('al agregar, la película aparece primero en la lista', () async {
    final notifier = container.read(favoriteMoviesProvider.notifier);
    await notifier.toggleFavoriteMovie(makeMovie(id: 1));
    await notifier.toggleFavoriteMovie(makeMovie(id: 2));

    final movies = container.read(favoriteMoviesProvider).movies;
    expect(movies.first.id, 2);
  });

  test('loadNextPage pagina desde el almacenamiento local', () async {
    for (var id = 1; id <= 3; id++) {
      await container
          .read(favoriteMoviesProvider.notifier)
          .toggleFavoriteMovie(makeMovie(id: id));
    }

    final notifier = container.read(favoriteMoviesProvider.notifier);
    await notifier.loadNextPage();

    final state = container.read(favoriteMoviesProvider);
    expect(state.movies, hasLength(3));
    expect(state.hasMore, isFalse);
  });

  test('quitar una película no cargada no la agrega a la lista', () async {
    // La película es favorita pero no está en la primera página cargada.
    fakeDataSource.favorites[77] = makeMovie(id: 77);
    fakeDataSource.favorites[78] = makeMovie(id: 78);
    fakeDataSource.favorites[79] = makeMovie(id: 79);

    final notifier = container.read(favoriteMoviesProvider.notifier);
    await notifier.loadNextPage();
    expect(container.read(favoriteMoviesProvider).movies, hasLength(3));

    // Se quita desde la pantalla de detalles (estado ya cargado en lista).
    await notifier.toggleFavoriteMovie(makeMovie(id: 79));
    final state = container.read(favoriteMoviesProvider);
    expect(state.movies.map((movie) => movie.id), isNot(contains(79)));
    expect(fakeDataSource.favorites.containsKey(79), isFalse);
  });
}
