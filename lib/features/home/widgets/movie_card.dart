import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/shared/widgets/vote_average.dart';
import 'package:cinemapedia/shared/widgets/vote_count.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    const imageWidth = 135.0;
    const imageHeight = 220.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          SizedBox(
            width: imageWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              /// FadeInImage: Widget que permite mostrar una imagen con un efecto de transición.
              child: FadeInImage(
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor.
                placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                image: NetworkImage(movie.posterPath),
              ),
            ),
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
            child: Text(movie.title, maxLines: 2, style: textStyles.titleSmall),
          ),
        ],
      ),
    );
  }
}
