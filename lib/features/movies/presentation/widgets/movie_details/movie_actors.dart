import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter/material.dart';

class MovieActors extends StatelessWidget {
  final List<Actor> actors;

  const MovieActors({super.key, required this.actors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final Actor actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(10),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(actor.profilePath,
                        width: 135, height: 180, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 5),

                /// Nombre
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
