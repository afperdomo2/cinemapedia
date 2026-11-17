import 'package:cinemapedia/config/responsive.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';

class MovieActors extends StatelessWidget {
  final List<Actor> actors;

  const MovieActors({super.key, required this.actors});

  @override
  Widget build(BuildContext context) {
    // En tablets/escritorio las fichas crecen manteniendo la proporción 135×180
    final imageWidth =
        Responsive.posterCardWidth(MediaQuery.sizeOf(context).width);
    final imageHeight = imageWidth * 4 / 3;

    return SizedBox(
      height: imageHeight + 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final Actor actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(10),
            width: imageWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Image
                TmdbImage(
                  actor.profilePath,
                  size: TmdbImageSize.w185,
                  width: imageWidth,
                  height: imageHeight,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(height: 5),

                /// Name
                Text(
                  actor.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  actor.character ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
