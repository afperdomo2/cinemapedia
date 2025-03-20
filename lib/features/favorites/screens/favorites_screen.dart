import 'package:cinemapedia/features/favorites/providers/favorite_movies_provider.dart';
import 'package:cinemapedia/features/home/screens/home_screen.dart';
import 'package:cinemapedia/features/favorites/widgets/movies_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;

    if (favoriteMovies.isEmpty) {
      return const _FavoriteMoviesListEmpty();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            Text('Películas favoritas', style: titleStyle),
          ],
        ),
      ),
      body: MoviesMasonry(favoriteMovies, loadNextPage: loadNextPage),
    );
  }
}

class _FavoriteMoviesListEmpty extends StatelessWidget {
  const _FavoriteMoviesListEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60, color: Colors.red.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            'No hay películas favoritas',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Marca algunas películas como favoritas y aparecerán aquí',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () => context.goNamed(HomeScreen.name),
            child: const Text('Ver películas'),
          )
        ],
      ),
    );
  }
}
