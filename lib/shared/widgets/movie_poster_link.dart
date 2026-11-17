import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/movie_details/screens/movie_details_screen.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Póster navegable a los detalles de la película.
class MoviePosterLink extends StatelessWidget {
  const MoviePosterLink(this.movie, {super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ver detalles de ${movie.title}',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.pushNamed(
          MovieDetailsScreen.name,
          pathParameters: {'movieId': '${movie.id}'},
        ),
        child: TmdbImage(
          movie.posterPath,
          size: TmdbImageSize.w342,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
