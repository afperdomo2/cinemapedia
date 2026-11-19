import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Datos públicos de una persona (actor, dirección…).
///
/// Se conservan por sesión: volver atrás desde una película no los repide.
final personDetailsProvider =
    FutureProvider.family<Person, int>((ref, personId) {
  return ref.watch(movieRepositoryProvider).getPerson(personId);
});

/// Filmografía completa de una persona: reparto y equipo.
final personCreditsProvider =
    FutureProvider.family<PersonFilmography, int>((ref, personId) {
  return ref.watch(movieRepositoryProvider).getPersonMovieCredits(personId);
});
