import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/features/person/providers/person_providers.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movie_poster_link.dart';
import 'package:cinemapedia/shared/widgets/share_icon_button.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detalle de una persona: foto, datos, biografía y filmografía navegable.
class PersonScreen extends ConsumerWidget {
  static const name = 'person-screen';

  const PersonScreen({super.key, required this.personId});

  final int personId;

  void _retry(WidgetRef ref) {
    ref.invalidate(personDetailsProvider(personId));
    ref.invalidate(personCreditsProvider(personId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = ref.watch(personDetailsProvider(personId));
    final creditsAsync = ref.watch(personCreditsProvider(personId));
    final person = personAsync.valueOrNull;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(person?.name ?? 'Persona'),
            actions: [
              if (person != null) SharePersonIconButton(person),
            ],
          ),
          ...personAsync.when(
            loading: () => [
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ],
            error: (error, _) => [
              SliverFillRemaining(
                child: ErrorView(
                  message: moviesErrorMessage(error),
                  onRetry: () => _retry(ref),
                ),
              ),
            ],
            data: (person) =>
                _personSlivers(context, person, creditsAsync, ref),
          ),
        ],
      ),
    );
  }

  List<Widget> _personSlivers(
    BuildContext context,
    Person person,
    AsyncValue<List<Movie>> creditsAsync,
    WidgetRef ref,
  ) {
    return [
      /// Foto y datos básicos
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TmdbImage(
                person.profilePath,
                size: TmdbImageSize.w185,
                width: 110,
                height: 165,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if (person.knownForDepartment != null &&
                        person.knownForDepartment!.isNotEmpty)
                      _InfoRow(
                        icon: Icons.work_outline,
                        text: person.knownForDepartment!,
                      ),
                    if (person.birthday != null)
                      _InfoRow(
                        icon: Icons.cake_outlined,
                        text: _formatBirthday(person.birthday!),
                      ),
                    if (person.placeOfBirth != null &&
                        person.placeOfBirth!.isNotEmpty)
                      _InfoRow(
                        icon: Icons.place_outlined,
                        text: person.placeOfBirth!,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// Biografía
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Biografía', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                (person.biography.trim().isEmpty)
                    ? 'No hay biografía disponible.'
                    : person.biography,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 16),
              Text('Filmografía',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),

      /// Filmografía
      ...creditsAsync.when(
        loading: () => [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
        ],
        error: (error, _) => [
          SliverToBoxAdapter(
            child: ErrorView(
              message: moviesErrorMessage(error),
              compact: true,
              onRetry: () => ref.invalidate(personCreditsProvider(personId)),
            ),
          ),
        ],
        data: (movies) {
          if (movies.isEmpty) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Sin filmografía registrada.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ];
          }
          return [
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => MoviePosterLink(movies[index]),
                  childCount: movies.length,
                ),
              ),
            ),
          ];
        },
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ];
  }

  String _formatBirthday(String birthday) {
    final date = DateTime.tryParse(birthday);
    return (date == null) ? birthday : HumanFormatter.shortDate(date);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colors.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
