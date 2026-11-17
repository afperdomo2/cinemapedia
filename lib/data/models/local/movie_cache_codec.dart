import 'dart:convert';

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/video.dart';

/// Serialización JSON de las entidades de dominio para el caché local.
///
/// El formato es propio de la app (no el de TMDB): si una entidad cambia,
/// basta con actualizar este códec y las entradas viejas se descartan solas
/// al no poder decodificarse.
class MovieCacheCodec {
  const MovieCacheCodec._();

  static String encodeMoviePage(MoviePage page) => jsonEncode({
        'movies': [for (final movie in page.movies) _movieToMap(movie)],
        'page': page.page,
        'totalPages': page.totalPages,
      });

  static MoviePage decodeMoviePage(String payload, {bool fromCache = true}) {
    final map = jsonDecode(payload) as Map<String, dynamic>;
    return MoviePage(
      movies: [
        for (final item in map['movies'] as List)
          _movieFromMap(item as Map<String, dynamic>),
      ],
      page: map['page'] as int,
      totalPages: map['totalPages'] as int,
      fromCache: fromCache,
    );
  }

  static String encodeMovieDetails(MovieDetails details) => jsonEncode({
        'movie': _movieToMap(details.movie),
        'actors': [for (final actor in details.actors) _actorToMap(actor)],
        'videos': [for (final video in details.videos) _videoToMap(video)],
        'similarMovies': [
          for (final movie in details.similarMovies) _movieToMap(movie),
        ],
      });

  static MovieDetails decodeMovieDetails(String payload) {
    final map = jsonDecode(payload) as Map<String, dynamic>;
    return MovieDetails(
      movie: _movieFromMap(map['movie'] as Map<String, dynamic>),
      actors: [
        for (final item in map['actors'] as List)
          _actorFromMap(item as Map<String, dynamic>),
      ],
      videos: [
        for (final item in map['videos'] as List)
          _videoFromMap(item as Map<String, dynamic>),
      ],
      similarMovies: [
        for (final item in map['similarMovies'] as List)
          _movieFromMap(item as Map<String, dynamic>),
      ],
    );
  }

  static String encodeMovies(List<Movie> movies) =>
      jsonEncode([for (final movie in movies) _movieToMap(movie)]);

  static List<Movie> decodeMovies(String payload) => [
        for (final item in jsonDecode(payload) as List)
          _movieFromMap(item as Map<String, dynamic>),
      ];

  static String encodePerson(Person person) => jsonEncode(_personToMap(person));

  static Person decodePerson(String payload) =>
      _personFromMap(jsonDecode(payload) as Map<String, dynamic>);

  static String encodeGenres(List<Genre> genres) => jsonEncode([
        for (final genre in genres) {'id': genre.id, 'name': genre.name},
      ]);

  static List<Genre> decodeGenres(String payload) => [
        for (final item in jsonDecode(payload) as List)
          Genre(
            id: (item as Map<String, dynamic>)['id'] as int,
            name: item['name'] as String,
          ),
      ];

  static Map<String, dynamic> _personToMap(Person person) => {
        'id': person.id,
        'name': person.name,
        'biography': person.biography,
        'profilePath': person.profilePath,
        'birthday': person.birthday,
        'placeOfBirth': person.placeOfBirth,
        'knownForDepartment': person.knownForDepartment,
      };

  static Person _personFromMap(Map<String, dynamic> map) => Person(
        id: map['id'] as int,
        name: map['name'] as String,
        biography: map['biography'] as String,
        profilePath: map['profilePath'] as String,
        birthday: map['birthday'] as String?,
        placeOfBirth: map['placeOfBirth'] as String?,
        knownForDepartment: map['knownForDepartment'] as String?,
      );

  static Map<String, dynamic> _movieToMap(Movie movie) => {
        'adult': movie.adult,
        'backdropPath': movie.backdropPath,
        'genreIds': movie.genreIds,
        'id': movie.id,
        'originalLanguage': movie.originalLanguage,
        'originalTitle': movie.originalTitle,
        'overview': movie.overview,
        'popularity': movie.popularity,
        'posterPath': movie.posterPath,
        'releaseDate': movie.releaseDate?.toIso8601String(),
        'title': movie.title,
        'video': movie.video,
        'voteAverage': movie.voteAverage,
        'voteCount': movie.voteCount,
      };

  static Movie _movieFromMap(Map<String, dynamic> map) => Movie(
        adult: map['adult'] as bool,
        backdropPath: map['backdropPath'] as String,
        genreIds: List<String>.from(map['genreIds'] as List),
        id: map['id'] as int,
        originalLanguage: map['originalLanguage'] as String,
        originalTitle: map['originalTitle'] as String,
        overview: map['overview'] as String,
        popularity: (map['popularity'] as num).toDouble(),
        posterPath: map['posterPath'] as String,
        releaseDate: map['releaseDate'] == null
            ? null
            : DateTime.parse(map['releaseDate'] as String),
        title: map['title'] as String,
        video: map['video'] as bool,
        voteAverage: (map['voteAverage'] as num).toDouble(),
        voteCount: map['voteCount'] as int,
      );

  static Map<String, dynamic> _actorToMap(Actor actor) => {
        'id': actor.id,
        'name': actor.name,
        'profilePath': actor.profilePath,
        'character': actor.character,
      };

  static Actor _actorFromMap(Map<String, dynamic> map) => Actor(
        id: map['id'] as int,
        name: map['name'] as String,
        profilePath: map['profilePath'] as String,
        character: map['character'] as String?,
      );

  static Map<String, dynamic> _videoToMap(Video video) => {
        'id': video.id,
        'name': video.name,
        'youtubeKey': video.youtubeKey,
        'publishedAt': video.publishedAt.toIso8601String(),
      };

  static Video _videoFromMap(Map<String, dynamic> map) => Video(
        id: map['id'] as String,
        name: map['name'] as String,
        youtubeKey: map['youtubeKey'] as String,
        publishedAt: DateTime.parse(map['publishedAt'] as String),
      );
}
