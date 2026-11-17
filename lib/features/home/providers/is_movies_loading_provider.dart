import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/features/home/providers/movies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `true` mientras las cuatro listas de Home cargan su primera página.
///
/// En cuanto alguna termine (bien o con error), Home muestra el contenido y
/// cada sección renderiza su propio estado: así una lista lenta o caída no
/// deja la pantalla entera en un loader infinito.
final isMoviesLoadingProvider = Provider<bool>((ref) {
  final states = [
    ref.watch(nowPlayingMoviesProvider),
    ref.watch(popularMoviesProvider),
    ref.watch(topRatedMoviesProvider),
    ref.watch(upcomingMoviesProvider),
  ];

  return states.every((MoviesState state) => state.isInitialLoading);
});

/// `true` si las cuatro listas fallaron: se muestra una pantalla de error
/// única en lugar de cuatro errores repetidos.
final isMoviesErrorProvider = Provider<bool>((ref) {
  final states = [
    ref.watch(nowPlayingMoviesProvider),
    ref.watch(popularMoviesProvider),
    ref.watch(topRatedMoviesProvider),
    ref.watch(upcomingMoviesProvider),
  ];

  return states.every((MoviesState state) => state.hasError);
});
