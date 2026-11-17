import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/movie_details/screens/movie_details_screen.dart';
import 'package:cinemapedia/providers/search_movie_provider.dart';
import 'package:cinemapedia/shared/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/shared/services/recent_searches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Botón de búsqueda de películas, disponible desde cualquier pantalla.
///
/// Al cerrar la búsqueda con una película elegida, navega a sus detalles.
class MovieSearchIconButton extends ConsumerWidget {
  const MovieSearchIconButton({super.key});

  Future<void> _openSearch(BuildContext context, WidgetRef ref) async {
    final searchQuery = ref.read(searchQueryProvider);
    final searchedMovies = ref.read(searchedMoviesProvider);
    final searchMoviesByQuery =
        ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery;
    final recentSearches = await RecentSearches.load();

    if (!context.mounted) return;

    final movie = await showSearch<Movie?>(
      context: context,
      query: searchQuery,
      delegate: SearchMovieDelegate(
        searchMovies: searchMoviesByQuery,
        initialMovies: searchedMovies,
        recentSearches: recentSearches,
      ),
    );

    if (movie == null || !context.mounted) return;
    context.pushNamed(MovieDetailsScreen.name,
        pathParameters: {'movieId': '${movie.id}'});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Buscar películas',
      onPressed: () => _openSearch(context, ref),
      icon: const Icon(Icons.search),
    );
  }
}
