import 'dart:async';

import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/common/widgets/scaffold_with_bottom_navbar.dart';
import 'package:cinemapedia/features/home/providers/movies_provider.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movies_grid.dart';
import 'package:cinemapedia/shared/widgets/movie_search_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularScreen extends ConsumerStatefulWidget {
  static const name = 'popular-screen';

  const PopularScreen({super.key});

  @override
  ConsumerState<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends ConsumerState<PopularScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() => ref.read(popularMoviesProvider.notifier).refresh();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;

    // Re-tocar el tab "Populares" vuelve al tope de la grilla.
    ref.listen(tabReselectProvider, (previous, next) {
      if (next == null || next.index != 1) return;
      if (_scrollController.hasClients) {
        unawaited(_scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        ));
      }
    });

    final state = ref.watch(popularMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.star_outlined, color: Colors.yellow[700]),
            const SizedBox(width: 8),
            Text('Películas populares', style: titleStyle),
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
            unawaited(ref.read(popularMoviesProvider.notifier).loadNextPage()),
      );
    }

    return MoviesGrid(
      state,
      controller: _scrollController,
      onLoadMore: () =>
          unawaited(ref.read(popularMoviesProvider.notifier).loadNextPage()),
    );
  }
}
