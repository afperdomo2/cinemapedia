import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/home/providers/movies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proveedor de las películas destacadas del slideshow (máximo 10).
///
/// `take` es seguro aunque TMDB devuelva menos de 10 resultados.
final moviesSlideShowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider).movies;
  return nowPlayingMovies.take(10).toList();
});
