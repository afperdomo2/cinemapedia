import 'dart:async';

import 'package:cinemapedia/common/widgets/scaffold_with_bottom_navbar.dart';
import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/features/genres/providers/genres_provider.dart';
import 'package:cinemapedia/features/genres/screens/movies_by_genre_screen.dart';
import 'package:cinemapedia/features/random/screens/random_movie_screen.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movie_search_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla "Explorar": todos los géneros de TMDB como entrada al catálogo.
class GenresScreen extends ConsumerStatefulWidget {
  static const name = 'genres-screen';

  const GenresScreen({super.key});

  @override
  ConsumerState<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends ConsumerState<GenresScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(genresProvider);
    await ref.read(genresProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium;
    final genresAsync = ref.watch(genresProvider);

    // Re-tocar el tab "Explorar" vuelve al tope de la grilla.
    ref.listen(tabReselectProvider, (previous, next) {
      if (next == null || next.index != 3) return;
      if (_scrollController.hasClients) {
        unawaited(_scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        ));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.explore_outlined),
            const SizedBox(width: 8),
            Text('Explorar', style: titleStyle),
          ],
        ),
        actions: const [MovieSearchIconButton()],
      ),
      body: Column(
        children: [
          const _SuggestionBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: genresAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, _) => ErrorView(
                  message: moviesErrorMessage(error),
                  onRetry: () => ref.invalidate(genresProvider),
                ),
                data: (genres) => _GenresGrid(
                  genres: genres,
                  controller: _scrollController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Entrada a "¿Qué ver hoy?".
class _SuggestionBanner extends StatelessWidget {
  const _SuggestionBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.pushNamed(RandomMovieScreen.name),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.casino_outlined, size: 32, color: colors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¿Qué ver hoy?',
                          style: textStyles.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(
                        'Una sugerencia al azar para vos',
                        style: textStyles.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenresGrid extends StatelessWidget {
  const _GenresGrid({required this.genres, required this.controller});

  final List<Genre> genres;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.all(12),
      // Tarjetas de ancho máximo: se adaptan a móvil, tablet y escritorio.
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisExtent: 96,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        return _GenreCard(genre: genre);
      },
    );
  }
}

class _GenreCard extends StatelessWidget {
  const _GenreCard({required this.genre});

  final Genre genre;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(
          MoviesByGenreScreen.name,
          pathParameters: {'genreId': '${genre.id}'},
          extra: genre.name,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_iconFor(genre.id), size: 28, color: colors.primary),
              const Spacer(),
              Text(
                genre.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icono representativo por género de TMDB.
IconData _iconFor(int genreId) {
  switch (genreId) {
    case 28: // Acción
      return Icons.local_fire_department_outlined;
    case 12: // Aventura
      return Icons.explore_outlined;
    case 16: // Animación
      return Icons.animation;
    case 35: // Comedia
      return Icons.sentiment_very_satisfied_outlined;
    case 80: // Crimen
      return Icons.gpp_maybe_outlined;
    case 99: // Documental
      return Icons.menu_book_outlined;
    case 18: // Drama
      return Icons.theater_comedy_outlined;
    case 10751: // Familia
      return Icons.family_restroom_outlined;
    case 14: // Fantasía
      return Icons.auto_awesome_outlined;
    case 36: // Historia
      return Icons.account_balance_outlined;
    case 27: // Terror
      return Icons.nightlight_outlined;
    case 10402: // Música
      return Icons.music_note_outlined;
    case 9648: // Misterio
      return Icons.search_outlined;
    case 10749: // Romance
      return Icons.favorite_outline;
    case 878: // Ciencia ficción
      return Icons.rocket_launch_outlined;
    case 53: // Suspense
      return Icons.visibility_outlined;
    case 10752: // Bélica
      return Icons.military_tech_outlined;
    case 37: // Western
      return Icons.wb_sunny_outlined;
    default:
      return Icons.movie_filter_outlined;
  }
}
