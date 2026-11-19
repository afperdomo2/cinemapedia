/// Orden de resultados para explorar el catálogo (`/discover/movie`).
enum MovieSort {
  populares('Populares'),
  mejorValoradas('Mejor valoradas'),
  recientes('Más recientes');

  const MovieSort(this.label);

  /// Etiqueta mostrada en los chips.
  final String label;

  /// Parámetros que TMDB espera para este orden.
  Map<String, dynamic> get queryParameters {
    return switch (this) {
      MovieSort.populares => {'sort_by': 'popularity.desc'},
      // Sin un mínimo de votos, el top lo llenan películas con un solo voto.
      MovieSort.mejorValoradas => {
          'sort_by': 'vote_average.desc',
          'vote_count.gte': 50
        },
      MovieSort.recientes => {'sort_by': 'primary_release_date.desc'},
    };
  }
}

/// Combinación de género, orden y año para explorar el catálogo.
///
/// Es la clave de la lista paginada: cada combinación tiene su propia
/// paginación y su propia entrada en el caché.
class GenreFilter {
  const GenreFilter({
    required this.genreId,
    this.sortBy = MovieSort.populares,
    this.releaseYear,
  });

  final int genreId;
  final MovieSort sortBy;

  /// Año de estreno (`primary_release_year`); `null` para cualquier año.
  final int? releaseYear;

  Map<String, dynamic> get queryParameters => {
        'with_genres': genreId,
        ...sortBy.queryParameters,
        if (releaseYear != null) 'primary_release_year': releaseYear,
      };

  @override
  bool operator ==(Object other) =>
      other is GenreFilter &&
      other.genreId == genreId &&
      other.sortBy == sortBy &&
      other.releaseYear == releaseYear;

  @override
  int get hashCode => Object.hash(genreId, sortBy, releaseYear);

  @override
  String toString() =>
      'GenreFilter(genreId: $genreId, sortBy: $sortBy, year: $releaseYear)';
}
