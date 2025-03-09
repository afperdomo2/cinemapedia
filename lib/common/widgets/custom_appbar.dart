import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/features/movies/presentation/providers/search/search_movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium;

    final searchQuery = ref.watch(searchQueryProvider);
    final searchMoviesByQuery = ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery;
    final searchedMovies = ref.watch(searchedMoviesProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              Text('Cinemapedia', style: titleStyle),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      searchMovies: searchMoviesByQuery,
                      initialMovies: searchedMovies,
                    ),
                  ).then((movie) {
                    /// Esta línea se usa direccionar cuando se cierra la búsqueda
                    // if (movie != null) {
                    //   context.push('/movie/${movie.id}');
                    // }
                  });
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
