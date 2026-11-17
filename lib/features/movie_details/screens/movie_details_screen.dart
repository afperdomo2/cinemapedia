import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:cinemapedia/features/home/widgets/movies_horizontal_listview.dart';
import 'package:cinemapedia/features/movie_details/providers/movie_details_provider.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_actors.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_details_appbar.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_genres.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_resume.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_videos.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailsScreen extends ConsumerWidget {
  static const name = 'movie_screen';

  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(movieDetailsProvider(movieId));

    return detailsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: error is FetchException
              ? error.message
              : 'No se pudo cargar la información de la película.',
          onRetry: () => ref.invalidate(movieDetailsProvider(movieId)),
        ),
      ),
      data: (details) => _MovieDetailsView(details: details),
    );
  }
}

class _MovieDetailsView extends StatelessWidget {
  const _MovieDetailsView({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    final movie = details.movie;
    final similarMovies = details.similarMovies;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          /// App bar con la imagen de la película
          MovieDetailsAppBar(movie: movie),

          /// Contenido de la película
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieResume(movie: movie),
                  MovieGenres(movie: movie),
                  MovieActors(actors: details.actors),

                  /// Videos
                  MovieVideos(details.videos, movieId: movie.id),
                  const SizedBox(height: 7),

                  /// Recomendaciones
                  if (similarMovies.isNotEmpty)
                    MoviesHorizontalListView(
                      MoviesState(movies: similarMovies, hasMore: false),
                      title: 'Recomendaciones',
                    ),
                  const SizedBox(height: 50),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
