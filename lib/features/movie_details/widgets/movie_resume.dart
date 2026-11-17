import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
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
          /// Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(movie.posterPath, width: posterWidth, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),

          /// Descripción
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Título
                Text(movie.title, style: textStyles.titleLarge!.copyWith(fontSize: 28)),
                const SizedBox(height: 10),

                /// Resumen
                Text(movie.overview != '' ? movie.overview : 'No se encontró una descripción'),
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
                    const Text('Estreno:', style: TextStyle(fontWeight: FontWeight.bold)),
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
