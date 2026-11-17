import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:cinemapedia/features/movie_details/providers/movie_details_provider.dart';
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

  test('devuelve los detalles completos de la película', () async {
    final details = await container.read(movieDetailsProvider(1).future);

    expect(details.movie.id, 1);
    expect(details.actors, hasLength(1));
    expect(details.videos, hasLength(1));
    expect(details.similarMovies, hasLength(1));
    expect(fakeRepository.calls, ['details:1']);
  });

  test('cachea los detalles por id (una sola petición por película)', () async {
    await container.read(movieDetailsProvider(5).future);
    await container.read(movieDetailsProvider(5).future);

    expect(fakeRepository.calls, ['details:5']);
  });

  test('propaga los errores de dominio para mostrarlos y reintentar', () async {
    fakeRepository.detailsError =
        const FetchException('La API key de TMDB no es válida.');

    await expectLater(
      container.read(movieDetailsProvider(2).future),
      throwsA(isA<FetchException>()),
    );

    // Tras invalidar, reintenta la petición.
    fakeRepository.detailsError = null;
    container.invalidate(movieDetailsProvider(2));
    final details = await container.read(movieDetailsProvider(2).future);

    expect(details.movie.id, 2);
    expect(fakeRepository.calls, ['details:2', 'details:2']);
  });
}
