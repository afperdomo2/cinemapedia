import 'package:cinemapedia/domain/entities/video.dart';
import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieVideos extends StatelessWidget {
  final List<Video> videos;

  const MovieVideos(this.videos, {super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

// class _YouTubeVideoPlayer extends StatefulWidget {
//   final String youtubeId;
//   final String name;

//   const _YouTubeVideoPlayer({required this.youtubeId, required this.name});

//   @override
//   State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
// }

// class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = YoutubePlayerController(
//       initialVideoId: widget.youtubeId,
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: false,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: YoutubePlayerBuilder(
//         player: YoutubePlayer(controller: _controller),
//         builder: (context, player) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(widget.name),
//               player,
//               const SizedBox(height: 20),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
