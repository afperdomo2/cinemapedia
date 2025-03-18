import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieVideos extends StatelessWidget {
  final List<Video> videos;

  const MovieVideos(this.videos, {super.key});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const Center(child: Text('No hay videos disponibles'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Videos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250, // Adjust height as needed
          child: Swiper(
            itemCount: videos.length,
            viewportFraction: 0.8,
            scale: 0.92,
            itemBuilder: (context, index) {
              final video = videos[index];
              return _YouTubeVideoPlayer(youtubeId: video.youtubeKey, name: video.name);
            },
          ),
        ),
      ],
    );
  }
}

class _YouTubeVideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String name;

  const _YouTubeVideoPlayer({required this.youtubeId, required this.name});

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(controller: _controller),
          Text(widget.name),
        ],
      ),
    );
  }
}
