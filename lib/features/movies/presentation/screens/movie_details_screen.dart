import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/providers/movie_details_provider.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movie_details/movie_details.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movie_details/movie_details_appbar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailsProvider)[widget.movieId];
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
                MovieDetailsAppBar(movie: movie),
                SliverList(
                  delegate: SliverChildListDelegate([
                    MovieDetails(movie),
                  ]),
                ),
              ],
            )
          : const Center(child: Text('Movie not found')),
    );
  }
}
