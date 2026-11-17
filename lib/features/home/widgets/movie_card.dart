import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:cinemapedia/shared/widgets/vote_average.dart';
import 'package:cinemapedia/shared/widgets/vote_count.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  /// Ancho de la imagen; el alto se calcula con la proporción original 135×220.
  final double imageWidth;

  const MovieCard(this.movie, {super.key, this.imageWidth = 135.0});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    final imageHeight = imageWidth * 220 / 135;

    return SizedBox(
      width: imageWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          TmdbImage(
            movie.posterPath,
            size: TmdbImageSize.w342,
            width: imageWidth,
            height: imageHeight,
            borderRadius: BorderRadius.circular(20),
          ),

          const SizedBox(height: 5),

          /// Rating
          SizedBox(
            width: imageWidth,
            child: Row(
              children: [
                VoteAverage(movie.voteAverage),
                const Spacer(),
                VoteCount(movie.voteCount),
                const SizedBox(width: 2),
              ],
            ),
          ),

          /// Title
          SizedBox(
            width: imageWidth,
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyles.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
