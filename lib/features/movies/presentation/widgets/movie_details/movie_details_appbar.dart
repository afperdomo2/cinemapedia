import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/providers/favorite_movies_provider.dart';
import 'package:cinemapedia/features/movies/presentation/providers/repositories/local_storage_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// Provider para saber si una película es favorita
///
/// FutureProvider: Proveedor de un valor futuro
/// autoDispose: Se elimina automáticamente cuando no se usa
/// family: Proveedor de una familia de valores
///
final isFavoriteMovieProvider = FutureProvider.autoDispose.family<bool, int>((ref, movieId) {
  final localStorageProvider = ref.watch(localStorageRepositoryProvider);
  return localStorageProvider.isFavoriteMovie(movieId);
});

class MovieDetailsAppBar extends ConsumerWidget {
  final Movie movie;

  const MovieDetailsAppBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteMovie = ref.watch(isFavoriteMovieProvider(movie.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await ref.read(favoriteMoviesProvider.notifier).toggleFavoriteMovie(movie);

            /// Invalidar el provider para que se vuelva a cargar
            ref.invalidate(isFavoriteMovieProvider(movie.id));
          },
          icon: isFavoriteMovie.when(
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_outline),
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
            error: (error, _) => const Icon(Icons.favorite_outline),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
        // title: Text(
        //   movie.title,
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(fontSize: 24, color: Colors.white),
        // ),
        background: Stack(
          children: [
            // Poster
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  return (loadingProgress == null) ? FadeIn(child: child) : const SizedBox();
                },
              ),
            ),

            // Gradiente inferior
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1],
              colors: [Colors.transparent, Colors.black54],
            ),

            // Gradiente superior izquierdo
            const _CustomGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.12],
              colors: [Colors.black54, Colors.transparent],
            ),

            // Gradiente superior derecho
            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.12],
              colors: [Colors.black54, Colors.transparent],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin,
    required this.end,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: begin, end: end, stops: stops, colors: colors),
        ),
      ),
    );
  }
}
