import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/genres/providers/genres_provider.dart';
import 'package:cinemapedia/features/movie_details/screens/movie_details_screen.dart';
import 'package:cinemapedia/features/random/providers/random_movie_provider.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/skeleton.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// "¿Qué ver hoy?": una sugerencia al azar, con filtros y opción de repetir.
class RandomMovieScreen extends ConsumerStatefulWidget {
  static const name = 'random-movie-screen';

  const RandomMovieScreen({super.key});

  @override
  ConsumerState<RandomMovieScreen> createState() => _RandomMovieScreenState();
}

class _RandomMovieScreenState extends ConsumerState<RandomMovieScreen> {
  int? _genreId;
  double? _minRating;

  void _applyFilters() {
    ref
        .read(randomMovieProvider.notifier)
        .setFilters(genreId: _genreId, minVoteAverage: _minRating);
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = ref.watch(randomMovieProvider);
    final genresAsync = ref.watch(genresProvider);
    final genres = genresAsync.valueOrNull ?? const <Genre>[];

    return Scaffold(
      appBar: AppBar(title: const Text('¿Qué ver hoy?')),
      body: Column(
        children: [
          _FilterBar(
            genres: genres,
            genreId: _genreId,
            minRating: _minRating,
            onGenreChanged: (genreId) {
              setState(() => _genreId = genreId);
              _applyFilters();
            },
            onRatingChanged: (minRating) {
              setState(() => _minRating = minRating);
              _applyFilters();
            },
          ),
          Expanded(
            child: suggestion.when(
              loading: () => const _SuggestionSkeleton(),
              error: (error, _) => ErrorView(
                message: 'No pudimos sugerirte una película. Probá de nuevo.',
                onRetry: () => ref.read(randomMovieProvider.notifier).redraw(),
              ),
              data: (movie) => (movie == null)
                  ? const SizedBox.shrink()
                  : _SuggestionCard(
                      movie: movie,
                      genres: genres,
                      onRedraw: () =>
                          ref.read(randomMovieProvider.notifier).redraw(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filtros de la sugerencia: género opcional y nota mínima.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.genres,
    required this.genreId,
    required this.minRating,
    required this.onGenreChanged,
    required this.onRatingChanged,
  });

  final List<Genre> genres;
  final int? genreId;
  final double? minRating;
  final ValueChanged<int?> onGenreChanged;
  final ValueChanged<double?> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          DropdownButton<int?>(
            value: genreId,
            isDense: true,
            underline: const SizedBox.shrink(),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Cualquier género'),
              ),
              for (final genre in genres)
                DropdownMenuItem(
                  value: genre.id,
                  child: Text(genre.name),
                ),
            ],
            onChanged: onGenreChanged,
          ),
          for (final (label, value) in [
            ('Cualquier nota', null),
            ('7+', 7.0),
            ('8+', 8.0),
          ])
            ChoiceChip(
              label: Text(label),
              selected: minRating == value,
              onSelected: (_) => onRatingChanged(value),
            ),
        ],
      ),
    );
  }
}

/// La sugerencia: imagen grande, datos y acciones.
class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.movie,
    required this.genres,
    required this.onRedraw,
  });

  final Movie movie;
  final List<Genre> genres;
  final VoidCallback onRedraw;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final genreNames = [
      for (final id in movie.genreIds)
        for (final genre in genres)
          if ('${genre.id}' == id) genre.name,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmdbImage(
            movie.backdropPath,
            size: TmdbImageSize.w780,
            height: 220,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  movie.title,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Icon(Icons.star, color: colors.primary, size: 20),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            [
              if (movie.releaseDate != null) '${movie.releaseDate!.year}',
              ...genreNames,
            ].join(' · '),
            style: theme.textTheme.bodySmall
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Text(
            movie.overview.isEmpty
                ? 'Sin sinopsis disponible.'
                : movie.overview,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: onRedraw,
                icon: const Icon(Icons.casino_outlined),
                label: const Text('Otra sugerencia'),
              ),
              FilledButton.icon(
                onPressed: () => context.pushNamed(
                  MovieDetailsScreen.name,
                  pathParameters: {'movieId': '${movie.id}'},
                ),
                icon: const Icon(Icons.movie_outlined),
                label: const Text('Ver detalles'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mientras se piensa la sugerencia: tarjeta fantasma con el mismo tamaño.
class _SuggestionSkeleton extends StatelessWidget {
  const _SuggestionSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: const [
        SkeletonBox(height: 220, borderRadius: 16),
        SizedBox(height: 12),
        SkeletonBox(width: 220, height: 24),
        SizedBox(height: 8),
        SkeletonBox(width: 140, height: 14),
        SizedBox(height: 16),
        SkeletonBox(height: 90),
        SizedBox(height: 16),
        SkeletonBox(width: 180, height: 40),
      ],
    );
  }
}
