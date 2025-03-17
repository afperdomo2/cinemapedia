import 'package:cinemapedia/data/models/tmdb/movie_videos_tmdb_response.dart';
import 'package:cinemapedia/domain/entities/video.dart';

class VideoMapper {
  static movieVideoTMDbResponseToEntity(MovieVideoTMDbResponse movieVideo) {
    return Video(
      id: movieVideo.id,
      name: movieVideo.name,
      youtubeKey: movieVideo.key,
      publishedAt: movieVideo.publishedAt,
    );
  }
}
