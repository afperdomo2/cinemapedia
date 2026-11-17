import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Reproductor fullscreen de los videos de una película, con playlist.
///
/// Se abre desde la sección "Videos" de los detalles. El `YoutubePlayer`
/// maneja su propio formato 16:9, por lo que no desborda en ningún ancho.
class VideoScreen extends StatefulWidget {
  static const name = 'video_screen';

  final List<Video> videos;
  final int initialIndex;

  const VideoScreen({
    super.key,
    required this.videos,
    this.initialIndex = 0,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  late int _currentVideoIndex;

  Video get _currentVideo => widget.videos[_currentVideoIndex];

  @override
  void initState() {
    super.initState();
    _currentVideoIndex = widget.initialIndex.clamp(0, widget.videos.length - 1);
    _controller = YoutubePlayerController(
      initialVideoId: _currentVideo.youtubeKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo(int index) {
    if (index == _currentVideoIndex) return;
    setState(() => _currentVideoIndex = index);
    _controller.load(widget.videos[index].youtubeKey);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_currentVideo.name,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          body: Column(
            children: [
              player,
              if (widget.videos.length > 1)
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.videos.length,
                    itemBuilder: (context, index) {
                      final video = widget.videos[index];
                      return ListTile(
                        selected: index == _currentVideoIndex,
                        title: Text(video.name,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://img.youtube.com/vi/${video.youtubeKey}/default.jpg',
                            width: 96,
                            height: 54,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.videocam_off),
                          ),
                        ),
                        onTap: () => _playVideo(index),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
