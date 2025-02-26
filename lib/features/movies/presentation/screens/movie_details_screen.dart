import 'package:cinemapedia/features/movies/domain/entities/actor.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/providers/actors_by_movie_provider.dart';
import 'package:cinemapedia/features/movies/presentation/providers/movie_details_provider.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movie_details/movie_actors.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movie_details/movie_details_appbar.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movie_details/movie_genres.dart';
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

    final bool isLoading =
        ref.watch(movieDetailsProvider.notifier).isLoading || ref.watch(actorByMovieProvider.notifier).isLoading;

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
                MovieDetailsAppBar(movie: movie),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MovieResume(movie: movie),
                        MovieGenres(movie: movie),
                        MovieActors(actors: actors),
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
}

class _MovieResume extends StatelessWidget {
  const _MovieResume({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(movie.posterPath, width: size.width * 0.3, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),

          /// Descripción
          SizedBox(
            width: (size.width - 45) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Título
                Text(movie.title, style: textStyles.titleLarge!.copyWith(fontSize: 28)),

                /// Resumen
                const SizedBox(height: 10),
                Text(movie.overview),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
