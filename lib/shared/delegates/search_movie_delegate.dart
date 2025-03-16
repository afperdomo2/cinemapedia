import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/shared/widgets/vote_average.dart';
import 'package:cinemapedia/shared/widgets/vote_count.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;
  List<Movie> initialMovies;

  late StreamController<List<Movie>> debounceMovies;
  late StreamController<bool> isLoadingStream;

  bool _isDebounceMoviesClosed = false;
  bool _isLoadingStreamClosed = false;
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  }) {
    debounceMovies = StreamController<List<Movie>>.broadcast();
    isLoadingStream = StreamController<bool>.broadcast();
  }

  @override
  String get searchFieldLabel => 'Buscar películas';

  void _onQueryChanged(String query) {
    if (_isLoadingStreamClosed) return;

    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

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
          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
          );
        },
      ),
    ];
  }

  /// Botón de regreso
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        resetMovieStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  /// Cerrar streams al cerrar la búsqueda de películas para evitar fugas de memoria
  /// y errores de ejecución en la aplicación al intentar acceder a un stream cerrado.
  @override
  void close(BuildContext context, Movie? result) {
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
        if (query.isEmpty) {
          return const _SearchInputEmpty();
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
                context.push('/movie/${movie.id}');
              },
              child: _MovieItem(movie),
            );
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              width: size.width * 0.2,
              height: size.width * 0.3,
              fit: BoxFit.cover,
              image: NetworkImage(movie.posterPath),
            ),
          ),

          /// Title and overview
          const SizedBox(width: 10),
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(movie.title, style: textStyles.titleLarge!.copyWith(fontSize: 20)),
                const SizedBox(height: 5),

                /// Overview
                Text(
                  movie.overview != '' ? movie.overview : 'No se encontró una descripción',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                /// Release date, rating and vote count
                Row(
                  children: [
                    /// Release date
                    Text(movie.releaseDate?.year.toString() ?? '--', style: textStyles.titleSmall),
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
    );
  }
}

class _SearchInputEmpty extends StatelessWidget {
  const _SearchInputEmpty();

  @override
  Widget build(BuildContext context) {
    const message = 'Ingresa el nombre de una película para buscarla';
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
