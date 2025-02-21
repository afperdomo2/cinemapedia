import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_provider.dart';

final isMoviesLoadingProvider = Provider<bool>((ref) {
  final isNowPlayingMoviesEmpty = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final isPopularMoviesEmpty = ref.watch(popularMoviesProvider).isEmpty;
  final isTopRatedMoviesEmpty = ref.watch(topRatedMoviesProvider).isEmpty;
  final isUpcomingMoviesEmpty = ref.watch(upcomingMoviesProvider).isEmpty;

  final isLoading = isNowPlayingMoviesEmpty || isPopularMoviesEmpty || isTopRatedMoviesEmpty || isUpcomingMoviesEmpty;

  return isLoading;
});
