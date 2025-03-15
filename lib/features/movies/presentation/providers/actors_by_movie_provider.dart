import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/features/movies/presentation/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final fetchMovieActors = ref.watch(movieRepositoryProvider).getMovieActors;
  return ActorsByMovieNotifier(fetchMovieActors: fetchMovieActors);
});

typedef MovieActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  bool isLoading = false;
  MovieActorsCallback fetchMovieActors;

  ActorsByMovieNotifier({
    required this.fetchMovieActors,
  }) : super({});

  Future<void> loadMovieActors(String movieId) async {
    if (isLoading) return;
    isLoading = true;
    final List<Actor> actors = await fetchMovieActors(movieId);
    state = {...state, movieId: actors};
    isLoading = false;
  }
}
