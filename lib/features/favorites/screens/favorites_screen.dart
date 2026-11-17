import 'dart:async';

import 'package:cinemapedia/common/state/movies_notifier.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/common/widgets/scaffold_with_bottom_navbar.dart';
import 'package:cinemapedia/features/favorites/providers/favorite_movies_provider.dart';
import 'package:cinemapedia/features/favorites/providers/watchlist_movies_provider.dart';
import 'package:cinemapedia/features/home/screens/home_screen.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movies_grid.dart';
import 'package:cinemapedia/shared/widgets/movie_search_icon_button.dart';
import 'package:cinemapedia/shared/widgets/skeleton.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 8),
              Text('Mis listas', style: titleStyle),
            ],
          ),
          actions: const [MovieSearchIconButton()],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite_outline), text: 'Favoritos'),
              Tab(icon: Icon(Icons.bookmark_outline), text: 'Quiero ver'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MoviesListTab(
              provider: favoriteMoviesProvider,
              emptyState: const _EmptyList(
                icon: Icons.favorite_border,
                title: 'No hay películas favoritas',
                message:
                    'Marca algunas películas como favoritas y aparecerán aquí',
              ),
            ),
            _MoviesListTab(
              provider: watchlistMoviesProvider,
              emptyState: const _EmptyList(
                icon: Icons.bookmark_border,
                title: 'No hay películas en "Quiero ver"',
                message:
                    'Guarda las películas que quieras ver y aparecerán aquí',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Una de las pestañas: lista paginada con pull-to-refresh y estado vacío.
class _MoviesListTab extends ConsumerStatefulWidget {
  const _MoviesListTab({
    required this.provider,
    required this.emptyState,
  });

  final NotifierProvider<MoviesNotifier, MoviesState> provider;
  final Widget emptyState;

  @override
  ConsumerState<_MoviesListTab> createState() => _MoviesListTabState();
}

class _MoviesListTabState extends ConsumerState<_MoviesListTab> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() => ref.read(widget.provider.notifier).refresh();

  @override
  Widget build(BuildContext context) {
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

    final state = ref.watch(widget.provider);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: _buildBody(state),
    );
  }

  Widget _buildBody(MoviesState state) {
    if (state.isInitialLoading) {
      return const MoviesSkeletonGrid();
    }

    if (state.hasError) {
      return ErrorView(
        message: state.errorMessage!,
        onRetry: () =>
            unawaited(ref.read(widget.provider.notifier).loadNextPage()),
      );
    }

    if (state.movies.isEmpty) {
      return widget.emptyState;
    }

    return MoviesGrid(
      state,
      controller: _scrollController,
      onLoadMore: () =>
          unawaited(ref.read(widget.provider.notifier).loadNextPage()),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: colors.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text(
            message,
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
