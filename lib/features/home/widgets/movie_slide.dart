import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';

class MovieSlide extends StatelessWidget {
  final Movie movie;

  /// Tag del hero hacia el encabezado de detalles; `null` si no debe animar.
  final String? heroTag;

  const MovieSlide(this.movie, {super.key, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: boxDecoration, // Añade una sombra alrededor del contenedor.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Background image (hero hacia el encabezado de detalles)
              _BackdropHero(
                heroTag: heroTag,
                movie: movie,
              ),

              /// Gradient overlay for better text visibility
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.8, 0.95],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2)
                      ],
                    ),
                  ),
                ),
              ),

              /// Movie title
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 11.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackdropHero extends StatelessWidget {
  const _BackdropHero({required this.heroTag, required this.movie});

  final String? heroTag;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final image = TmdbImage(
      movie.backdropPath,
      size: TmdbImageSize.w780,
    );

    if (heroTag == null) return image;
    return Hero(tag: heroTag!, child: image);
  }
}
