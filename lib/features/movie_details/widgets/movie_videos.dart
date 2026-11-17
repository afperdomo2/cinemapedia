import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/features/movie_details/screens/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Muestra las miniaturas de los trailers/ videos de la película.
///
/// El reproductor vive en [VideoScreen]: se abre al tocar una miniatura, así
/// nunca hay varios players de YouTube cargados a la vez.
class MovieVideos extends StatelessWidget {
  final List<Video> videos;
  final int movieId;

  const MovieVideos(this.videos, {super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Text('Videos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
              const SizedBox(width: 5),
              Text(
                '(${videos.length})',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return _VideoThumbnail(
                video: video,
                onTap: () => context.pushNamed(
                  VideoScreen.name,
                  pathParameters: {'movieId': '$movieId'},
                  extra: (videos: videos, initialIndex: index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail({required this.video, required this.onTap});

  final Video video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Miniatura de YouTube en 16:9 (320x180).
    const thumbnailWidth = 220.0;
    const thumbnailHeight = thumbnailWidth * 9 / 16;

    return Semantics(
      button: true,
      label: 'Reproducir ${video.name}',
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://img.youtube.com/vi/${video.youtubeKey}/mqdefault.jpg',
                      width: thumbnailWidth,
                      height: thumbnailHeight,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: thumbnailWidth,
                        height: thumbnailHeight,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: const Icon(Icons.videocam_off_outlined),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.play_circle_fill,
                    size: 48,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: thumbnailWidth,
                child: Text(
                  video.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
