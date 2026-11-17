import 'package:cinemapedia/data/mappers/movie_local_mapper.dart';
import 'package:cinemapedia/data/mappers/movie_mapper.dart';
import 'package:cinemapedia/data/models/tmdb/movie_details_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/movie_tmdb_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  group('MovieMapper', () {
    test('conserva las rutas relativas de las imágenes', () {
      final movie = MovieTMDbResponse.fromJson({
        'adult': false,
        'backdrop_path': '/backdrop.jpg',
        'genre_ids': [28, 12],
        'id': 42,
        'original_language': 'en',
        'original_title': 'Original',
        'overview': 'Resumen',
        'popularity': 12.5,
        'poster_path': '/poster.jpg',
        'release_date': '2026-03-01',
        'title': 'Título',
        'video': false,
        'vote_average': 8.1,
        'vote_count': 250,
      });

      final entity = MovieMapper.movieTMDbResponseToEntity(movie);

      expect(entity.posterPath, '/poster.jpg');
      expect(entity.backdropPath, '/backdrop.jpg');
      expect(entity.genreIds, ['28', '12']);
      expect(entity.id, 42);
    });

    test('en los detalles usa los nombres de géneros', () {
      final details = MovieDetailsTMDbResponse.fromJson({
        'adult': false,
        'backdrop_path': '',
        'budget': 0,
        'genres': [
          {'id': 28, 'name': 'Acción'},
          {'id': 35, 'name': 'Comedia'},
        ],
        'homepage': '',
        'id': 7,
        'origin_country': ['US'],
        'original_language': 'en',
        'original_title': 'Original',
        'overview': '',
        'popularity': 1,
        'poster_path': '',
        'production_companies': [],
        'production_countries': [],
        'release_date': '2025-12-24',
        'revenue': 0,
        'runtime': 120,
        'spoken_languages': [],
        'status': 'Released',
        'tagline': '',
        'title': 'Título',
        'video': false,
        'vote_average': 6,
        'vote_count': 10,
      });

      final entity = MovieMapper.movieDetailsTMDbResponseToEntity(details);

      expect(entity.genreIds, ['Acción', 'Comedia']);
      expect(entity.title, 'Título');
    });
  });

  group('resiliencia de modelos TMDB', () {
    test('soporta release_date nulo o vacío', () {
      final withNull =
          MovieTMDbResponse.fromJson(_movieJson('release_date', null));
      final withEmpty =
          MovieTMDbResponse.fromJson(_movieJson('release_date', ''));

      expect(withNull.releaseDate, isNull);
      expect(withEmpty.releaseDate, isNull);
    });

    test('soporta campos de lista ausentes', () {
      final movie = MovieTMDbResponse.fromJson({'id': 1});

      expect(movie.genreIds, isEmpty);
      expect(movie.overview, '');
      expect(movie.voteAverage, 0);
    });
  });

  group('MovieLocalMapper', () {
    test('entidad → persistencia → entidad conserva los datos', () {
      final movie = makeMovie(id: 99, title: 'Ida y vuelta');

      final roundTrip =
          MovieLocalMapper.toEntity(MovieLocalMapper.fromEntity(movie));

      expect(roundTrip.id, 99);
      expect(roundTrip.title, 'Ida y vuelta');
      expect(roundTrip.posterPath, movie.posterPath);
      expect(roundTrip.genreIds, movie.genreIds);
      expect(roundTrip.releaseDate, movie.releaseDate);
      expect(roundTrip.voteAverage, movie.voteAverage);
    });
  });
}

Map<String, dynamic> _movieJson(String key, Object? value) {
  return {
    'adult': false,
    'backdrop_path': '',
    'genre_ids': [],
    'id': 1,
    'original_language': 'en',
    'original_title': '',
    'overview': '',
    'popularity': 0,
    'poster_path': '',
    key: value,
    'title': 'Título',
    'video': false,
    'vote_average': 0,
    'vote_count': 0,
  };
}
