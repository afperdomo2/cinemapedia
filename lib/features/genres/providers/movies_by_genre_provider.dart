import 'dart:async';

import 'package:cinemapedia/common/state/movies_notifier.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Películas de un género, paginadas con infinite scroll.
///
/// Cada género tiene su propia instancia con su paginación independiente.
final moviesByGenreProvider =
    NotifierProvider.family<MoviesByGenreNotifier, MoviesState, int>(
  MoviesByGenreNotifier.new,
);

class MoviesByGenreNotifier extends FamilyNotifier<MoviesState, int>
    with PaginatedMovies {
  @override
  MoviePageFetcher get fetcher => ({int page = 1}) {
        return ref
            .read(movieRepositoryProvider)
            .discoverMoviesByGenre(arg, page: page);
      };

  @override
  MoviesState build(int genreId) {
    // La carga inicial se posterga porque `build()` puede ejecutarse durante
    // la fase de build de los widgets, donde no se puede modificar el estado.
    unawaited(Future.microtask(loadNextPage));
    return const MoviesState(isLoading: true);
  }
}
