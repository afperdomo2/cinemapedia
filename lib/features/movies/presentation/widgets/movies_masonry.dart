import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class MoviesMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MoviesMasonry(this.movies, {super.key, this.loadNextPage});

  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if (index >= widget.movies.length) {
            return const SizedBox.shrink();
          }
          final movie = widget.movies[index];
          if (index == 1) {
            return Column(
              children: [const SizedBox(height: 40), _MoviePosterLink(movie)],
            );
          }
          return _MoviePosterLink(movie);
        },
      ),
    );
  }
}

class _MoviePosterLink extends StatelessWidget {
  const _MoviePosterLink(this.movie);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/movie/${movie.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(movie.posterPath, fit: BoxFit.cover),
      ),
    );
  }
}
