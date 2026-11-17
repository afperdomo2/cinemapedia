import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Última consulta escrita en el buscador (para reabrirla con contexto).
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Últimos resultados de búsqueda, para sembrar el delegate al reabrirlo.
final searchedMoviesProvider =
    NotifierProvider<SearchedMoviesNotifier, List<Movie>>(
  SearchedMoviesNotifier.new,
);

class SearchedMoviesNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() => const [];

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final result = await ref.read(movieRepositoryProvider).searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = result.movies;
    return result.movies;
  }
}
