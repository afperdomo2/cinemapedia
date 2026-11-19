import 'package:cinemapedia/data/models/local/movie_cache_codec.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  group('roundtrip', () {
    test('página de películas', () {
      final page = MoviePage(
        movies: [makeMovie(id: 1), makeMovie(id: 2)],
        page: 3,
        totalPages: 9,
      );

      final payload = MovieCacheCodec.encodeMoviePage(page);
      final decoded = MovieCacheCodec.decodeMoviePage(payload);

      expect(decoded.page, 3);
      expect(decoded.totalPages, 9);
      expect(decoded.fromCache, isTrue);
      expect(
        decoded.movies.map((movie) => movie.id),
        [1, 2],
      );
    });

    test('detalles de película con actores, videos y similares', () {
      final details = makeMovieDetails(1);

      final payload = MovieCacheCodec.encodeMovieDetails(details);
      final decoded = MovieCacheCodec.decodeMovieDetails(payload);

      expect(decoded.movie.id, details.movie.id);
      expect(decoded.actors.single.name, 'Actor');
      expect(decoded.videos.single.youtubeKey, 'abc123');
      expect(decoded.similarMovies.single.id, details.similarMovies.single.id);
    });

    test('persona', () {
      final person = makePerson(7);

      final payload = MovieCacheCodec.encodePerson(person);
      final decoded = MovieCacheCodec.decodePerson(payload);

      expect(decoded.id, 7);
      expect(decoded.name, 'Persona');
      expect(decoded.birthday, '1980-05-20');
    });

    test('filmografía con reparto y equipo', () {
      final filmography = makePersonFilmography();

      final payload = MovieCacheCodec.encodePersonFilmography(filmography);
      final decoded = MovieCacheCodec.decodePersonFilmography(payload);

      expect(decoded.cast, hasLength(2));
      expect(decoded.cast.first.character, 'Personaje 1');
      expect(decoded.direction.single.job, 'Director');
      expect(decoded.crewOther.single.department, 'Writing');
    });

    test('géneros', () {
      const genres = [Genre(id: 28, name: 'Acción')];

      final payload = MovieCacheCodec.encodeGenres(genres);
      final decoded = MovieCacheCodec.decodeGenres(payload);

      expect(decoded.single.id, 28);
      expect(decoded.single.name, 'Acción');
    });
  });

  group('tryDecode', () {
    test('devuelve null con payloads que no se entienden', () {
      expect(
        MovieCacheCodec.tryDecode(
            'no es json', MovieCacheCodec.decodeMoviePage),
        isNull,
      );
      expect(
        MovieCacheCodec.tryDecode('[1, 2]', MovieCacheCodec.decodeMoviePage),
        isNull,
      );
      expect(
        MovieCacheCodec.tryDecode('[1, 2]', MovieCacheCodec.decodePerson),
        isNull,
      );
    });

    test('un formato viejo de filmografía (lista plana) no rompe nada', () {
      // Formato anterior: una lista simple de películas.
      final legacy = MovieCacheCodec.encodeMovies([makeMovie(id: 1)]);

      expect(
        MovieCacheCodec.tryDecode(
            legacy, MovieCacheCodec.decodePersonFilmography),
        isNull,
      );
    });
  });
}
