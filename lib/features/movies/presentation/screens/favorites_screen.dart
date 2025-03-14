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
  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();
    print(favoriteMovies);
    final isLoading = ref.watch(favoriteMoviesProvider.notifier).isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: MoviesMasonry(favoriteMovies),
    );
  }
}
