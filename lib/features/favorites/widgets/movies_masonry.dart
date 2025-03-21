import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/shared/widgets/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoviesMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MoviesMasonry(this.movies, {super.key, this.loadNextPage});

  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      widget.loadNextPage?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if (index >= widget.movies.length) {
            return const SizedBox.shrink();
          }
          final movie = widget.movies[index];
          // Si es el segundo elemento, crea un espacio en blanco
          if (index == 1) {
            return Column(
              children: [const SizedBox(height: 40), MoviePosterLink(movie)],
            );
          }
          return MoviePosterLink(movie);
        },
      ),
    );
  }
}
