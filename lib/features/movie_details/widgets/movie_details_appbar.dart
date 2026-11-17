import 'dart:async';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/favorites/providers/favorite_movies_provider.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailsAppBar extends ConsumerWidget {
  final Movie movie;

  const MovieDetailsAppBar({super.key, required this.movie});

  Future<void> _toggleFavorite(BuildContext context, WidgetRef ref) async {
    final isFavorite = await ref
        .read(favoriteMoviesProvider.notifier)
        .toggleFavoriteMovie(movie);

    if (!context.mounted) return;

    unawaited(HapticFeedback.lightImpact());
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isFavorite
                ? 'Agregada a favoritos: ${movie.title}'
                : 'Eliminada de favoritos: ${movie.title}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteMovie = ref.watch(isFavoriteMovieProvider(movie.id));
    final size = MediaQuery.of(context).size;

    final isFavorite = isFavoriteMovie.valueOrNull ?? false;

    return SliverAppBar(
      backgroundColor: Colors.black,
      // En pantallas altas (tablet) se acota para no ocupar toda la pantalla
      expandedHeight: (size.height * 0.7).clamp(300.0, 600.0).toDouble(),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
          onPressed: () => _toggleFavorite(context, ref),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_outline,
            color: isFavorite ? Colors.red : null,
          ),
        ),
      ],

      /// FlexibleSpaceBar: Espacio flexible de la barra superior que se expande y colapsa
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
        background: Stack(
          children: [
            // Backdrop (hero desde el slideshow de inicio)
            Positioned.fill(
              child: Hero(
                tag: 'backdrop-${movie.id}',
                child: TmdbImage(
                  movie.backdropPath,
                  size: TmdbImageSize.w1280,
                ),
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
          gradient: LinearGradient(
              begin: begin, end: end, stops: stops, colors: colors),
        ),
      ),
    );
  }
}
