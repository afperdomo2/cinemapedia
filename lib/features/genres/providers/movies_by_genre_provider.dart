import 'dart:async';

import 'package:cinemapedia/common/state/movies_notifier.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/domain/entities/genre_filter.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Películas de un filtro de exploración, paginadas con infinite scroll.
///
/// Cada combinación de género + orden + año tiene su propia instancia con su
/// paginación independiente: cambiar un filtro no pierde lo cargado antes.
final moviesByGenreProvider =
    NotifierProvider.family<MoviesByGenreNotifier, MoviesState, GenreFilter>(
  MoviesByGenreNotifier.new,
);

class MoviesByGenreNotifier extends FamilyNotifier<MoviesState, GenreFilter>
    with PaginatedMovies {
  @override
  MoviePageFetcher get fetcher => ({int page = 1}) {
        return ref
            .read(movieRepositoryProvider)
            .discoverMovies(arg, page: page);
      };

  @override
  MoviesState build(GenreFilter filter) {
    // La carga inicial se posterga porque `build()` puede ejecutarse durante
    // la fase de build de los widgets, donde no se puede modificar el estado.
    unawaited(Future.microtask(loadNextPage));
    return const MoviesState(isLoading: true);
  }
}
