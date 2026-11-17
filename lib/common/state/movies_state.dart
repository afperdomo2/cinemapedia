import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de una lista paginada de películas.
///
/// Modela explícitamente la carga inicial, la paginación, el fin de datos y
/// los errores, para que la UI nunca quede en un loader infinito.
class MoviesState {
  const MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.fromCache = false,
  });

  final List<Movie> movies;

  /// Carga inicial (o refresh) en curso.
  final bool isLoading;

  /// Carga de la página siguiente en curso.
  final bool isLoadingMore;

  /// `false` cuando ya se cargaron todas las páginas disponibles.
  final bool hasMore;

  /// Mensaje del último error, o `null` si no hay error.
  final String? errorMessage;

  /// `true` si (parte de) el contenido se sirvió del caché local porque no
  /// había conexión. La UI muestra un aviso discreto.
  final bool fromCache;

  /// Hay contenido (o al menos una carga terminada): la pantalla puede render.
  bool get isInitialLoading => isLoading && movies.isEmpty;

  /// No hay nada que mostrar y la última carga falló.
  bool get hasError => errorMessage != null && movies.isEmpty;

  MoviesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
    bool? fromCache,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

typedef MoviePageFetcher = Future<MoviePage> Function({int page});

/// Resuelve el fetcher de una categoría usando el `ref` del notifier
/// (los `NotifierProvider` crean su notifier sin recibir `ref`).
typedef MovieFetcherSelector = MoviePageFetcher Function(Ref ref);

String moviesErrorMessage(Object error) {
  return error is FetchException
      ? error.message
      : 'No se pudo cargar las películas.';
}
