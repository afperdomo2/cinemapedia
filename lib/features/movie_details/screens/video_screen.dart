import 'package:cinemapedia/domain/entities/video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// NOTE: Actualmente no está en uso, pero sirve para mostrar el video en un screen
// independiente.
class VideoScreen extends StatefulWidget {
  final List<Video> videos;

  const VideoScreen({super.key, required this.videos});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  late int _currentVideoIndex;

  @override
  void initState() {
    super.initState();
    _currentVideoIndex = 0;
    _initializeController();
  }

  void _initializeController() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videos[_currentVideoIndex].youtubeKey,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videos[_currentVideoIndex].name),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return Column(
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
                        title: Text(video.name),
                        leading: Image.network(
                          'https://img.youtube.com/vi/${video.youtubeKey}/default.jpg',
                        ),
                        onTap: () {
                          setState(() {
                            _currentVideoIndex = index;
                            _controller.load(video.youtubeKey);
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
