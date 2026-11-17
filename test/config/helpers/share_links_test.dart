import 'package:cinemapedia/config/helpers/share_links.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  test('el texto compartido de una película lleva título, nota y enlace', () {
    final movie = makeMovie(id: 42, title: 'Película', voteAverage: 8.25);

    final text = ShareLinks.movieText(movie);

    expect(text, contains('Película'));
    expect(text, contains('8.3/10'));
    expect(text, contains('https://www.themoviedb.org/movie/42'));
  });

  test('el texto compartido de una persona lleva nombre y enlace', () {
    final person = makePerson(7, name: 'Persona');

    final text = ShareLinks.personText(person);

    expect(text, contains('Persona'));
    expect(text, contains('https://www.themoviedb.org/person/7'));
  });

  test('los enlaces de TMDB son públicos y navegables', () {
    expect(ShareLinks.movieUrl(1), 'https://www.themoviedb.org/movie/1');
    expect(ShareLinks.personUrl(2), 'https://www.themoviedb.org/person/2');
  });
}
