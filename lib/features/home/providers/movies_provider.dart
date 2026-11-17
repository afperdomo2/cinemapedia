import 'package:cinemapedia/common/state/movies_notifier.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider = NotifierProvider<MoviesNotifier, MoviesState>(
  () =>
      MoviesNotifier((ref) => ref.read(movieRepositoryProvider).getNowPlaying),
);

final popularMoviesProvider = NotifierProvider<MoviesNotifier, MoviesState>(
  () => MoviesNotifier((ref) => ref.read(movieRepositoryProvider).getPopular),
);

final topRatedMoviesProvider = NotifierProvider<MoviesNotifier, MoviesState>(
  () => MoviesNotifier((ref) => ref.read(movieRepositoryProvider).getTopRated),
);

final upcomingMoviesProvider = NotifierProvider<MoviesNotifier, MoviesState>(
  () => MoviesNotifier((ref) => ref.read(movieRepositoryProvider).getUpcoming),
);
