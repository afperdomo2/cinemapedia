import 'package:cinemapedia/features/random/providers/random_movie_provider.dart';
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

  test('al construir dibuja una sugerencia sin filtros', () async {
    final movie = await container.read(randomMovieProvider.future);

    expect(movie?.title, 'Sugerencia 1');
    expect(fakeRepository.calls, contains('random:null:null'));
  });

  test('redraw saca otra sugerencia distinta', () async {
    await container.read(randomMovieProvider.future);

    await container.read(randomMovieProvider.notifier).redraw();
    final movie = await container.read(randomMovieProvider.future);

    expect(movie?.title, 'Sugerencia 2');
  });

  test('setFilters aplica género y nota mínima', () async {
    await container.read(randomMovieProvider.future);

    await container
        .read(randomMovieProvider.notifier)
        .setFilters(genreId: 28, minVoteAverage: 7);

    expect(fakeRepository.calls, contains('random:28:7.0'));
    expect(
      container.read(randomMovieProvider).valueOrNull?.title,
      'Sugerencia 2',
    );
  });

  test('un error queda expuesto para que la pantalla pueda reintentar',
      () async {
    fakeRepository.randomError = Exception('Sin conexión');

    await expectLater(
      container.read(randomMovieProvider.future),
      throwsA(isA<Exception>()),
    );
    expect(container.read(randomMovieProvider).hasError, isTrue);
  });
}
