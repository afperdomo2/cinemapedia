import 'dart:async';

import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/common/widgets/scaffold_with_bottom_navbar.dart';
import 'package:cinemapedia/features/favorites/providers/favorite_movies_provider.dart';
import 'package:cinemapedia/features/home/screens/home_screen.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movies_grid.dart';
import 'package:cinemapedia/shared/widgets/movie_search_icon_button.dart';
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
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() =>
      ref.read(favoriteMoviesProvider.notifier).refresh();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;

    // Re-tocar el tab "Favoritos" vuelve al tope de la grilla.
    ref.listen(tabReselectProvider, (previous, next) {
      if (next == null || next.index != 2) return;
      if (_scrollController.hasClients) {
        unawaited(_scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        ));
      }
    });

    final state = ref.watch(favoriteMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            const SizedBox(width: 8),
            Text('Películas favoritas', style: titleStyle),
          ],
        ),
        actions: const [MovieSearchIconButton()],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(MoviesState state) {
    if (state.isInitialLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (state.hasError) {
      return ErrorView(
        message: state.errorMessage!,
        onRetry: () =>
            unawaited(ref.read(favoriteMoviesProvider.notifier).loadNextPage()),
      );
    }

    if (state.movies.isEmpty) {
      return const _FavoriteMoviesListEmpty();
    }

    return MoviesGrid(
      state,
      controller: _scrollController,
      onLoadMore: () =>
          unawaited(ref.read(favoriteMoviesProvider.notifier).loadNextPage()),
    );
  }
}

class _FavoriteMoviesListEmpty extends StatelessWidget {
  const _FavoriteMoviesListEmpty();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 60, color: colors.error.withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          Text(
            'No hay películas favoritas',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Marca algunas películas como favoritas y aparecerán aquí',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: colors.onSurfaceVariant),
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
