import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter/material.dart';

class MovieActors extends StatelessWidget {
  final List<Actor> actors;

  const MovieActors({super.key, required this.actors});

  @override
  Widget build(BuildContext context) {
    const imageHeight = 180.0;
    const imageWidth = 135.0;

    return SizedBox(
      height: 270,
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
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.cover,
                      image: NetworkImage(actor.profilePath),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                /// Name
                Text(actor.name, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  actor.character ?? '',
                  style: TextStyle(color: Colors.grey[600], overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
