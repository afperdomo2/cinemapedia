import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/features/movies/presentation/providers/repositories/local_storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  final LocalStorageRepository localStorageRepository;

  int page = 1;
  bool isLoading = false;

  StorageMoviesNotifier(this.localStorageRepository) : super({});

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final movies = await localStorageRepository.getFavoriteMovies(page: page, limit: 20);
    state = {
      ...state,
      ...Map.fromEntries(movies.map((movie) => MapEntry(movie.id, movie))),
    };
    page++;
    isLoading = false;
  }
}
