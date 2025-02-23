import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/providers/movie_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie_screen';

  final String movieId;

  const MovieScreen(this.movieId, {super.key});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
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
      appBar: AppBar(
        title: Text('Movie - ${widget.movieId}'),
      ),
      body: const Placeholder(),
    );
  }
}
