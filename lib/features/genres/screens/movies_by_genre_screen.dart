import 'dart:async';

import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/domain/entities/genre_filter.dart';
import 'package:cinemapedia/features/genres/providers/genres_provider.dart';
import 'package:cinemapedia/features/genres/providers/movies_by_genre_provider.dart';
import 'package:cinemapedia/shared/widgets/cached_content_banner.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movies_grid.dart';
import 'package:cinemapedia/shared/widgets/movie_search_icon_button.dart';
import 'package:cinemapedia/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Películas de un género con orden, filtro de año e infinite scroll.
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

  MovieSort _sortBy = MovieSort.populares;
  int? _year;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Filtro activo: cambia la clave del provider y con ella la lista.
  GenreFilter get _filter => GenreFilter(
        genreId: widget.genreId,
        sortBy: _sortBy,
        releaseYear: _year,
      );

  Future<void> _refresh() =>
      ref.read(moviesByGenreProvider(_filter).notifier).refresh();

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
    final state = ref.watch(moviesByGenreProvider(_filter));

    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: titleStyle),
        actions: const [MovieSearchIconButton()],
      ),
      body: Column(
        children: [
          _FilterBar(
            sortBy: _sortBy,
            year: _year,
            onSortChanged: (sort) => setState(() => _sortBy = sort),
            onYearChanged: (year) => setState(() => _year = year),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _buildBody(state),
            ),
          ),
        ],
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
        onRetry: () => unawaited(
            ref.read(moviesByGenreProvider(_filter).notifier).loadNextPage()),
      );
    }

    final grid = MoviesGrid(
      state,
      controller: _scrollController,
      onLoadMore: () => unawaited(
          ref.read(moviesByGenreProvider(_filter).notifier).loadNextPage()),
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

/// Orden y año de estreno de la pantalla de género.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.sortBy,
    required this.year,
    required this.onSortChanged,
    required this.onYearChanged,
  });

  final MovieSort sortBy;
  final int? year;
  final ValueChanged<MovieSort> onSortChanged;
  final ValueChanged<int?> onYearChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final currentYear = DateTime.now().year;
    final years = [for (var i = 0; i < 30; i++) currentYear - i];

    // `Wrap` en vez de `Row`: en pantallas angostas los controles pasan de
    // línea y nada queda tapado ni recortado.
    return Container(
      color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final sort in MovieSort.values)
            ChoiceChip(
              label: Text(sort.label),
              selected: sort == sortBy,
              onSelected: (_) => onSortChanged(sort),
            ),
          DropdownButton<int?>(
            value: year,
            isDense: true,
            underline: const SizedBox.shrink(),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Cualquier año'),
              ),
              for (final item in years)
                DropdownMenuItem(value: item, child: Text('$item')),
            ],
            onChanged: onYearChanged,
          ),
        ],
      ),
    );
  }
}
