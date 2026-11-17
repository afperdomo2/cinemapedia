import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:cinemapedia/shared/widgets/vote_average.dart';
import 'package:cinemapedia/shared/widgets/vote_count.dart';
import 'package:flutter/material.dart';

class MovieResume extends StatelessWidget {
  const MovieResume({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    // En tablets/escritorio el póster se acota para no crecer linealmente
    final posterWidth = (size.width * 0.3).clamp(110.0, 240.0).toDouble();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Poster (proporción 2:3; medidas explícitas porque el Row deja los
          /// ejes sin límites y un AspectRatio no tendría cómo resolver el alto)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TmdbImage(
              movie.posterPath,
              size: TmdbImageSize.w342,
              width: posterWidth,
              height: posterWidth * 3 / 2,
            ),
          ),
          const SizedBox(width: 10),

          /// Descripción
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Título
                Text(movie.title, style: textStyles.headlineSmall),
                const SizedBox(height: 10),

                /// Resumen
                _Overview(movie.overview),
                const SizedBox(height: 10),

                /// Rating
                Row(
                  children: [
                    /// Rating
                    VoteAverage(movie.voteAverage),
                    const SizedBox(width: 7),

                    /// Vote count
                    const Icon(Icons.circle, size: 4, color: Colors.grey),
                    const SizedBox(width: 7),
                    VoteCount(movie.voteCount),
                  ],
                ),
                const SizedBox(height: 10),

                /// Release Date
                Row(
                  children: [
                    const Text('Estreno:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    movie.releaseDate != null
                        ? Text(HumanFormatter.shortDate(movie.releaseDate!))
                        : const Text('No se encontró una fecha de estreno')
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Resumen con desplegado "Leer más / Leer menos" para textos largos.
class _Overview extends StatefulWidget {
  const _Overview(this.overview);

  final String overview;

  @override
  State<_Overview> createState() => _OverviewState();
}

class _OverviewState extends State<_Overview> {
  bool _expanded = false;

  static const _collapsedLines = 5;

  @override
  Widget build(BuildContext context) {
    final overview = widget.overview;
    final textStyles = Theme.of(context).textTheme;

    if (overview.isEmpty) {
      return const Text('No se encontró una descripción');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overview,
          maxLines: _expanded ? null : _collapsedLines,
          overflow: _expanded ? null : TextOverflow.ellipsis,
          style: textStyles.bodyMedium,
        ),
        if (overview.length > 120)
          TextButton(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Leer menos' : 'Leer más'),
          ),
      ],
    );
  }
}
