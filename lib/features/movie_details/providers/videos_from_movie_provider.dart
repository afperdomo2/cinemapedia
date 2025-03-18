import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videosFromMovieProvider = FutureProvider.family((ref, String movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getMovieYoutubeVideos(movieId);
});
