import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sugerencia aleatoria de "¿Qué ver hoy?".
final randomMovieProvider =
    AsyncNotifierProvider<RandomMovieNotifier, Movie?>(RandomMovieNotifier.new);

class RandomMovieNotifier extends AsyncNotifier<Movie?> {
  int? _genreId;
  double? _minVoteAverage;

  @override
  Future<Movie?> build() => _draw();

  Future<Movie> _draw() {
    return ref.read(movieRepositoryProvider).getRandomMovie(
          genreId: _genreId,
          minVoteAverage: _minVoteAverage,
        );
  }

  /// Cambia los filtros y saca una sugerencia nueva.
  Future<void> setFilters({int? genreId, double? minVoteAverage}) async {
    _genreId = genreId;
    _minVoteAverage = minVoteAverage;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_draw);
  }

  /// Otra sugerencia con los mismos filtros.
  Future<void> redraw() =>
      setFilters(genreId: _genreId, minVoteAverage: _minVoteAverage);
}
