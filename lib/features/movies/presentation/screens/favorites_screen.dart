import 'package:cinemapedia/features/movies/presentation/providers/favorite_movies_provider.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movies_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  static const name = 'favorites-screen';

  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    if (movies.isEmpty) {
      isLastPage = true;
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();
    // final isLoading = ref.watch(favoriteMoviesProvider.notifier).isLoading;

    // if (isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return Scaffold(
      body: MoviesMasonry(favoriteMovies, loadNextPage: loadNextPage),
    );
  }
}
