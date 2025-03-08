import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/providers/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateProvider
///
/// Propósito: Se utiliza para gestionar un estado simple y mutable. Es adecuado para
/// estados que no requieren lógica compleja.
///
/// Uso: Proporciona un estado que puede ser leído y actualizado directamente.
///
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final searchMovies = ref.read(movieRepositoryProvider).searchMovies;
  return SearchedMoviesNotifier(searchMovies: searchMovies, ref: ref);
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
