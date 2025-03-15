import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifierProvider
///
/// Propósito: StateNotifierProvider se utiliza para gestionar estados
/// complejos que requieren lógica de negocio. Utiliza un StateNotifier
/// para manejar el estado.
///
/// Uso: Proporciona un estado que puede ser leído y actualizado a través
/// de métodos definidos en el StateNotifier.
///
final movieDetailsProvider =
    StateNotifierProvider<MovieDetailsMapNotifier, Map<String, Movie>>((ref) {
  final fetchMovieDetails = ref.watch(movieRepositoryProvider).getMovieDetails;
  return MovieDetailsMapNotifier(fetchMovieDetails: fetchMovieDetails);
});

typedef MovieCallback = Future<Movie> Function(String movieId);

class MovieDetailsMapNotifier extends StateNotifier<Map<String, Movie>> {
  final MovieCallback fetchMovieDetails;
  bool isLoading = false;

  MovieDetailsMapNotifier({
    required this.fetchMovieDetails,
  }) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state.containsKey(movieId)) return;
    isLoading = true;
    // await Future.delayed(const Duration(milliseconds: 1000));
    final Movie movie = await fetchMovieDetails(movieId);
    state = {...state, movieId: movie};
    isLoading = false;
  }
}
