import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/home/widgets/movies_horizontal_listview.dart';
import 'package:cinemapedia/features/movie_details/providers/actors_by_movie_provider.dart';
import 'package:cinemapedia/features/movie_details/providers/movie_details_provider.dart';
import 'package:cinemapedia/features/movie_details/providers/similar_movies_provider.dart';
import 'package:cinemapedia/features/movie_details/providers/videos_from_movie_provider.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_actors.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_details_appbar.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_genres.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_resume.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_videos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  static const name = 'movie_screen';

  final String movieId;

  const MovieDetailsScreen(this.movieId, {super.key});

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieDetailsProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadMovieActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailsProvider)[widget.movieId];
    final List<Actor> actors = ref.watch(actorByMovieProvider)[widget.movieId] ?? [];

    final similarMoviesFuture = ref.watch(similarMoviesProvider(widget.movieId));
    final videosFromMovieFuture = ref.watch(videosFromMovieProvider(widget.movieId));

    final bool isLoading = ref.watch(movieDetailsProvider.notifier).isLoading;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: (isLoading == false && movie != null)
          ? CustomScrollView(
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
                        MovieActors(actors: actors),
                        videosFromMovieFuture.when(
                          error: (error, stackTrace) {
                            return const Center(child: Text('No se pudo cargar los videos'));
                          },
                          loading: loadingFuture,
                          data: (videos) => MovieVideos(videos),
                        ),
                        const SizedBox(height: 7),
                        similarMoviesFuture.when(
                          error: errorSimilarMovies,
                          loading: loadingFuture,
                          data: (movies) {
                            return MoviesHorizontalListView(movies, title: 'Recomendaciones');
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    )
                  ]),
                ),
              ],
            )
          : const Center(child: Text('Movie not found')),
    );
  }

  Widget loadingFuture() {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  Widget errorSimilarMovies(Object error, StackTrace? stackTrace) {
    return const Center(child: Text('No se pudo cargar las Recomendaciones'));
  }
}
