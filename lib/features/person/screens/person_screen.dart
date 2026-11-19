import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';
import 'package:cinemapedia/features/person/providers/person_providers.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movie_poster_link.dart';
import 'package:cinemapedia/shared/widgets/share_icon_button.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sección de la filmografía que muestran los chips.
enum _RoleFilter {
  reparto('Reparto'),
  direccion('Dirección'),
  equipo('Equipo');

  const _RoleFilter(this.label);

  final String label;
}

/// Detalle de una persona: foto, datos, biografía y filmografía navegable.
class PersonScreen extends ConsumerStatefulWidget {
  static const name = 'person-screen';

  const PersonScreen({super.key, required this.personId});

  final int personId;

  @override
  ConsumerState<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends ConsumerState<PersonScreen> {
  _RoleFilter _role = _RoleFilter.reparto;

  void _retry() {
    ref.invalidate(personDetailsProvider(widget.personId));
    ref.invalidate(personCreditsProvider(widget.personId));
  }

  @override
  Widget build(BuildContext context) {
    final personAsync = ref.watch(personDetailsProvider(widget.personId));
    final creditsAsync = ref.watch(personCreditsProvider(widget.personId));
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
                  onRetry: _retry,
                ),
              ),
            ],
            data: (person) => _personSlivers(context, person, creditsAsync),
          ),
        ],
      ),
    );
  }

  List<Widget> _personSlivers(
    BuildContext context,
    Person person,
    AsyncValue<PersonFilmography> creditsAsync,
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
            ],
          ),
        ),
      ),

      /// Filmografía (conocido por + grilla por rol)
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
              onRetry: () =>
                  ref.invalidate(personCreditsProvider(widget.personId)),
            ),
          ),
        ],
        data: (filmography) =>
            _filmographySlivers(context, person, filmography),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ];
  }

  List<Widget> _filmographySlivers(
    BuildContext context,
    Person person,
    PersonFilmography filmography,
  ) {
    final knownFor = filmography.knownFor(person.knownForDepartment);
    final credits = switch (_role) {
      _RoleFilter.reparto => filmography.cast,
      _RoleFilter.direccion => filmography.direction,
      _RoleFilter.equipo => filmography.crewOther,
    };

    if (filmography.cast.isEmpty && filmography.crew.isEmpty) {
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
      /// Conocido por
      if (knownFor.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Conocido por',
                style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      if (knownFor.isNotEmpty)
        SliverToBoxAdapter(
          child: SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: knownFor.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) =>
                  SizedBox(width: 130, child: _CreditItem(knownFor[index])),
            ),
          ),
        ),

      /// Filmografía por rol
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filmografía',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  for (final role in _RoleFilter.values)
                    ChoiceChip(
                      label: Text(role.label),
                      selected: role == _role,
                      onSelected: (_) => setState(() => _role = role),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      if (credits.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Sin créditos en esta sección.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisExtent: 250,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CreditItem(credits[index]),
              childCount: credits.length,
            ),
          ),
        ),
    ];
  }

  String _formatBirthday(String birthday) {
    final date = DateTime.tryParse(birthday);
    return (date == null) ? birthday : HumanFormatter.shortDate(date);
  }
}

/// Póster de una película con el rol de la persona debajo.
class _CreditItem extends StatelessWidget {
  const _CreditItem(this.credit);

  final PersonCredit credit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final subtitle = credit.character ?? credit.job ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: MoviePosterLink(credit.movie)),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
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
