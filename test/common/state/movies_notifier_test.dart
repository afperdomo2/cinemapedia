import 'dart:async';

import 'package:cinemapedia/common/state/movies_notifier.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late List<int> requestedPages;

  MoviePage pageOf(int page, {int totalPages = 3, int moviesPerPage = 1}) {
    return MoviePage(
      movies: [
        for (var i = 0; i < moviesPerPage; i++)
          makeMovie(id: page * 100 + i, title: 'Página $page'),
      ],
      page: page,
      totalPages: totalPages,
    );
  }

  ({ProviderContainer container, MoviesNotifier notifier}) build({
    required Future<MoviePage> Function(int page) fetch,
  }) {
    final provider = NotifierProvider<MoviesNotifier, MoviesState>(
      () => MoviesNotifier(
        (ref) => ({int page = 1}) {
          requestedPages.add(page);
          return fetch(page);
        },
      ),
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return (container: container, notifier: container.read(provider.notifier));
  }

  setUp(() => requestedPages = []);

  test('la carga inicial acumula la primera página', () async {
    final result = build(fetch: (page) async => pageOf(page));

    await result.notifier.loadNextPage();
    final state = result.notifier.state;
    expect(state.movies, hasLength(1));
    expect(state.hasMore, isTrue);
    expect(state.hasError, isFalse);
  });

  test('loadNextPage acumula páginas sin repetirlas', () async {
    final result = build(fetch: (page) async => pageOf(page));

    await result.notifier.loadNextPage();
    await result.notifier.loadNextPage();
    await result.notifier.loadNextPage();

    expect(requestedPages, [1, 2, 3]);
    expect(result.notifier.state.movies, hasLength(3));
  });

  test('no pide más páginas cuando se agotaron los resultados', () async {
    final result = build(fetch: (page) async => pageOf(page, totalPages: 1));

    await result.notifier.loadNextPage();
    await result.notifier.loadNextPage();

    expect(requestedPages, [1]);
    expect(result.notifier.state.hasMore, isFalse);
  });

  test('un error en la carga inicial queda expuesto y se puede reintentar',
      () async {
    var fail = true;
    final result = build(fetch: (page) async {
      if (fail) throw const FetchException('Sin conexión');
      return pageOf(page);
    });

    await result.notifier.loadNextPage();
    expect(result.notifier.state.hasError, isTrue);
    expect(result.notifier.state.errorMessage, 'Sin conexión');
    expect(result.notifier.state.isInitialLoading, isFalse);

    fail = false;
    await result.notifier.loadNextPage();

    expect(result.notifier.state.hasError, isFalse);
    expect(result.notifier.state.movies, hasLength(1));
  });

  test('un error al paginar conserva lo ya cargado y permite reintentar',
      () async {
    var fail = false;
    final result = build(fetch: (page) async {
      if (fail) throw const FetchException('Timeout');
      return pageOf(page);
    });

    await result.notifier.loadNextPage();
    fail = true;
    await result.notifier.loadNextPage();

    expect(result.notifier.state.movies, hasLength(1));
    expect(result.notifier.state.errorMessage, 'Timeout');
    expect(result.notifier.state.isLoadingMore, isFalse);

    fail = false;
    await result.notifier.loadNextPage();
    expect(result.notifier.state.movies, hasLength(2));
    expect(result.notifier.state.hasError, isFalse);
  });

  test('no dispara dos peticiones en paralelo', () async {
    final completer = Completer<MoviePage>();
    final result = build(fetch: (page) => completer.future);

    final first = result.notifier.loadNextPage();
    final second = result.notifier.loadNextPage();
    completer.complete(pageOf(1));
    await Future.wait([first, second]);

    expect(requestedPages, [1]);
  });

  test('refresh reemplaza el contenido y reinicia la paginación', () async {
    final result = build(fetch: (page) async => pageOf(page));

    await result.notifier.loadNextPage();
    await result.notifier.loadNextPage();
    await result.notifier.refresh();

    expect(result.notifier.state.movies, hasLength(1));
    expect(requestedPages, [1, 2, 1]);

    // Después del refresh la siguiente carga sigue en la página 2.
    await result.notifier.loadNextPage();
    expect(requestedPages, [1, 2, 1, 2]);
    expect(result.notifier.state.movies, hasLength(2));
  });

  test('refresh con error conserva el contenido anterior', () async {
    var fail = false;
    final result = build(fetch: (page) async {
      if (fail) throw const FetchException('Sin internet');
      return pageOf(page);
    });

    await result.notifier.loadNextPage();
    fail = true;
    await result.notifier.refresh();

    expect(result.notifier.state.movies, hasLength(1));
    expect(result.notifier.state.errorMessage, 'Sin internet');
  });

  test('traduce errores de dominio a mensajes para el usuario', () async {
    final result = build(fetch: (page) async => throw Exception('boom'));

    await result.notifier.loadNextPage();
    expect(
        result.notifier.state.errorMessage, 'No se pudo cargar las películas.');
  });
}
