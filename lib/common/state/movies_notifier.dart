import 'dart:async';

import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier genérico de listas paginadas de películas.
///
/// Cada categoría (cartelera, populares, mejor valoradas, próximamente,
/// favoritos) crea su propia instancia con su fetcher. Maneja:
///  - carga inicial automática + retry desde el error,
///  - paginación con `hasMore` (nunca pide páginas de más),
///  - refresh (pull-to-refresh) conservando el contenido anterior,
///  - errores de dominio traducidos a mensaje para el usuario.
class MoviesNotifier extends Notifier<MoviesState> {
  MoviesNotifier(this._selectFetcher);

  final MovieFetcherSelector _selectFetcher;

  bool _inFlight = false;
  int _currentPage = 0;

  MoviePageFetcher get _fetcher => _selectFetcher(ref);

  @override
  MoviesState build() {
    // La carga inicial se posterga porque `build()` puede ejecutarse durante
    // la fase de build de los widgets, donde no se puede modificar el estado.
    unawaited(Future.microtask(loadNextPage));
    return const MoviesState(isLoading: true);
  }

  Future<void> loadNextPage() async {
    if (_inFlight || !state.hasMore) return;
    _inFlight = true;

    final isFirstLoad = state.movies.isEmpty;
    state = state.copyWith(
      isLoading: isFirstLoad,
      isLoadingMore: !isFirstLoad,
      clearError: true,
    );

    try {
      final result = await _fetcher(page: _currentPage + 1);
      _currentPage = result.page;

      // Evita duplicados si un elemento de la página nueva ya se mostraba
      // (p. ej. un favorito recién agregado con el toggle).
      final existingIds = state.movies.map((movie) => movie.id).toSet();
      final newMovies = result.movies
          .where((movie) => !existingIds.contains(movie.id))
          .toList();

      state = MoviesState(
        movies: [...state.movies, ...newMovies],
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: moviesErrorMessage(error),
      );
    } finally {
      _inFlight = false;
    }
  }

  Future<void> refresh() async {
    if (_inFlight) return;
    _inFlight = true;

    _currentPage = 0;
    state = state.copyWith(isLoading: true, hasMore: true, clearError: true);

    try {
      final result = await _fetcher(page: 1);
      _currentPage = result.page;
      state = MoviesState(movies: result.movies, hasMore: result.hasMore);
    } catch (error) {
      // Conservamos el contenido anterior: mejor ver datos viejos que nada.
      state = state.copyWith(
        isLoading: false,
        errorMessage: moviesErrorMessage(error),
      );
    } finally {
      _inFlight = false;
    }
  }
}
