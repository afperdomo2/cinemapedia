import 'dart:async';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/shared/services/recent_searches.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:cinemapedia/shared/widgets/vote_average.dart';
import 'package:cinemapedia/shared/widgets/vote_count.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;
  final RecentSearches? recentSearches;
  List<Movie> initialMovies;

  late StreamController<List<Movie>> debounceMovies;
  late StreamController<bool> isLoadingStream;

  bool _isDebounceMoviesClosed = false;
  bool _isLoadingStreamClosed = false;
  bool _seeded = false;
  String _lastHandledQuery = '';
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
    this.recentSearches,
  }) {
    debounceMovies = StreamController<List<Movie>>.broadcast();
    isLoadingStream = StreamController<bool>.broadcast();
  }

  @override
  String get searchFieldLabel => 'Buscar películas';

  void _onQueryChanged(String query) {
    // Los resultados con los que se abrió la búsqueda ya cubren esta consulta.
    if (!_seeded) {
      _seeded = true;
      if (query.isNotEmpty && initialMovies.isNotEmpty) {
        _lastHandledQuery = query;
        return;
      }
    }

    // No repetir la misma búsqueda en cada rebuild del delegate.
    if (query == _lastHandledQuery) return;
    _lastHandledQuery = query;

    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      initialMovies = [];
      if (!_isDebounceMoviesClosed) debounceMovies.add(const []);
      if (!_isLoadingStreamClosed) isLoadingStream.add(false);
      return;
    }

    if (!_isLoadingStreamClosed) isLoadingStream.add(true);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (_isDebounceMoviesClosed) return;

      final movies = await searchMovies(query);
      initialMovies = movies;

      if (!_isDebounceMoviesClosed) debounceMovies.add(movies);
      if (!_isLoadingStreamClosed) isLoadingStream.add(false);
    });
  }

  void resetMovieStreams() {
    _debounceTimer?.cancel();
    if (!_isDebounceMoviesClosed) {
      _isDebounceMoviesClosed = true;
      debounceMovies.close();
    }
    if (!_isLoadingStreamClosed) {
      _isLoadingStreamClosed = true;
      isLoadingStream.close();
    }
  }

  /// Guarda la consulta en el historial local de búsquedas.
  void _saveSearch() {
    final query = this.query.trim();
    if (query.isEmpty) return;
    unawaited(recentSearches?.add(query) ?? Future<void>.value());
  }

  /// Botones de acción
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoadingStream.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            /// Indicador de carga
            return Container(
              margin: const EdgeInsets.only(right: 15),
              width: 20,
              height: 20,
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          }

          /// Botón para limpiar la búsqueda
          return AnimatedOpacity(
            opacity: query.isEmpty ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              tooltip: 'Limpiar búsqueda',
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  /// Botón de regreso
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Cerrar',
      onPressed: () {
        resetMovieStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  /// Cerrar streams al cerrar la búsqueda de películas para evitar fugas de
  /// memoria y errores al acceder a un stream cerrado.
  @override
  void close(BuildContext context, Movie? result) {
    _saveSearch();
    resetMovieStreams(); // Cierra los streams
    super.close(context, result); // Cierra la búsqueda
  }

  /// Resultados de la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  /// Sugerencias de búsqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }

  StreamBuilder<List<Movie>> buildResultsAndSuggestions() {
    return StreamBuilder(
      stream: debounceMovies.stream,
      initialData: initialMovies,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        if (query.trim().isEmpty) {
          return _SearchInputEmpty(
            recentSearches: recentSearches?.all ?? const [],
            onSearch: (search) => query = search,
          );
        }

        if (movies.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No encontramos resultados para «$query»',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie,
              // Al elegir una película se cierra la búsqueda y quien la abrió
              // navega a los detalles.
              onTap: () => close(context, movie),
            );
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem(this.movie, {required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    // En tablets/escritorio el póster se acota y el texto usa el ancho restante
    final posterWidth = (size.width * 0.2).clamp(70.0, 160.0).toDouble();

    return Semantics(
      button: true,
      label: 'Ver detalles de ${movie.title}',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: posterWidth,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child:
                        TmdbImage(movie.posterPath, size: TmdbImageSize.w185),
                  ),
                ),
              ),

              /// Title and overview
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      movie.title,
                      style: textStyles.titleLarge?.copyWith(fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    /// Overview
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'No se encontró una descripción',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    /// Release date, rating and vote count
                    Row(
                      children: [
                        /// Release date
                        Text(
                          movie.releaseDate?.year.toString() ?? '--',
                          style: textStyles.titleSmall,
                        ),
                        const SizedBox(width: 7),

                        /// Rating
                        const Icon(Icons.circle, size: 4, color: Colors.grey),
                        const SizedBox(width: 7),
                        VoteAverage(movie.voteAverage),

                        /// Vote count
                        const SizedBox(width: 7),
                        const Icon(Icons.circle, size: 4, color: Colors.grey),
                        const SizedBox(width: 7),
                        VoteCount(movie.voteCount),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInputEmpty extends StatelessWidget {
  const _SearchInputEmpty({
    required this.recentSearches,
    required this.onSearch,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    const message = 'Ingresa el nombre de una película para buscarla';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 24),
        Center(
            child:
                Text(message, style: Theme.of(context).textTheme.labelLarge)),
        if (recentSearches.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Búsquedas recientes',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final search in recentSearches)
                ActionChip(
                  avatar: const Icon(Icons.history, size: 18),
                  label: Text(search),
                  onPressed: () => onSearch(search),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
