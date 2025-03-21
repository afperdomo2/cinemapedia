import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/providers/repositories/local_storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  final LocalStorageRepository localStorageRepository;

  int page = 1;

  StorageMoviesNotifier(this.localStorageRepository) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.getFavoriteMovies(page: page, limit: 20);
    state = {
      ...state,
      ...Map.fromEntries(movies.map((movie) => MapEntry(movie.id, movie))),
    };
    page++;
    return movies;
  }

  Future<void> toggleFavoriteMovie(Movie movie) async {
    await localStorageRepository.toggleFavoriteMovie(movie);
    final isFavorite = state[movie.id] != null;
    if (isFavorite) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
