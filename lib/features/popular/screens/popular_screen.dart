import 'package:cinemapedia/features/favorites/widgets/movies_masonry.dart';
import 'package:cinemapedia/features/home/providers/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularScreen extends ConsumerWidget {
  static const name = 'popular-screen';

  const PopularScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMovies = ref.watch(popularMoviesProvider);

    if (popularMovies.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas populares'),
      ),
      body: MoviesMasonry(
        popularMovies,
        loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
      ),
    );
  }
}
