import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/providers/movies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider
///
/// Propósito: Provider se utiliza para proporcionar valores que no cambian
/// o que se calculan una vez y no necesitan ser actualizados.
///
/// Uso: Proporciona un valor que puede ser leído, pero no actualizado.
///
final moviewsSlideShowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  return nowPlayingMovies.isNotEmpty ? nowPlayingMovies.sublist(0, 10) : [];
});
