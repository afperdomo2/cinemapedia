import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviewsSlideShowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  return nowPlayingMovies.isNotEmpty ? nowPlayingMovies.sublist(0, 10) : [];
});
