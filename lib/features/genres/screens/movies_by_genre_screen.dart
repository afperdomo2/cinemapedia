import 'dart:async';

import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/features/genres/providers/genres_provider.dart';
import 'package:cinemapedia/features/genres/providers/movies_by_genre_provider.dart';
import 'package:cinemapedia/shared/widgets/cached_content_banner.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movies_grid.dart';
import 'package:cinemapedia/shared/widgets/movie_search_icon_button.dart';
import 'package:cinemapedia/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Películas de un género con infinite scroll y pull-to-refresh.
class MoviesByGenreScreen extends ConsumerStatefulWidget {
  static const name = 'movies-by-genre-screen';

  const MoviesByGenreScreen({
    super.key,
    required this.genreId,
    this.genreName,
  });

  final int genreId;

  /// Nombre del género cuando se llega desde "Explorar"; puede faltar en
  /// navegación directa (deep link) y se resuelve con [genresProvider].
  final String? genreName;

  @override
  ConsumerState<MoviesByGenreScreen> createState() =>
      _MoviesByGenreScreenState();
}

class _MoviesByGenreScreenState extends ConsumerState<MoviesByGenreScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() =>
      ref.read(moviesByGenreProvider(widget.genreId).notifier).refresh();

  /// El título viene en la navegación o se busca en los géneros cargados.
  String get _title {
    final name = widget.genreName;
    if (name != null && name.isNotEmpty) return name;

    final genres = ref.watch(genresProvider).valueOrNull ?? const [];
    for (final genre in genres) {
      if (genre.id == widget.genreId) return genre.name;
    }
    return 'Películas';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;
    final state = ref.watch(moviesByGenreProvider(widget.genreId));

    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: titleStyle),
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
      return const MoviesSkeletonGrid();
    }

    if (state.hasError) {
      return ErrorView(
        message: state.errorMessage!,
        onRetry: () => unawaited(ref
            .read(moviesByGenreProvider(widget.genreId).notifier)
            .loadNextPage()),
      );
    }

    final grid = MoviesGrid(
      state,
      controller: _scrollController,
      onLoadMore: () => unawaited(ref
          .read(moviesByGenreProvider(widget.genreId).notifier)
          .loadNextPage()),
    );

    if (!state.fromCache) return grid;

    return Column(
      children: [
        const CachedContentBanner(),
        Expanded(child: grid),
      ],
    );
  }
}
