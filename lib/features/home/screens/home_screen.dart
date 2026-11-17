import 'dart:async';

import 'package:cinemapedia/common/widgets/custom_appbar.dart';
import 'package:cinemapedia/common/widgets/scaffold_with_bottom_navbar.dart';
import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:cinemapedia/features/home/providers/is_movies_loading_provider.dart';
import 'package:cinemapedia/features/home/providers/movies_provider.dart';
import 'package:cinemapedia/features/home/providers/movies_slideshow_provider.dart';
import 'package:cinemapedia/features/home/widgets/movies_horizontal_listview.dart';
import 'package:cinemapedia/features/home/widgets/movies_slideshow.dart';
import 'package:cinemapedia/shared/widgets/cached_content_banner.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  ConsumerState<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Reintenta las cuatro cargas (desde el estado de error).
  void _retryAll() {
    unawaited(ref.read(nowPlayingMoviesProvider.notifier).loadNextPage());
    unawaited(ref.read(popularMoviesProvider.notifier).loadNextPage());
    unawaited(ref.read(topRatedMoviesProvider.notifier).loadNextPage());
    unawaited(ref.read(upcomingMoviesProvider.notifier).loadNextPage());
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      ref.read(nowPlayingMoviesProvider.notifier).refresh(),
      ref.read(popularMoviesProvider.notifier).refresh(),
      ref.read(topRatedMoviesProvider.notifier).refresh(),
      ref.read(upcomingMoviesProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Re-tocar el tab "Inicio" vuelve al tope de la pantalla.
    ref.listen(tabReselectProvider, (previous, next) {
      if (next == null || next.index != 0) return;
      if (_scrollController.hasClients) {
        unawaited(_scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        ));
      }
    });

    final isMoviesLoading = ref.watch(isMoviesLoadingProvider);
    final isMoviesError = ref.watch(isMoviesErrorProvider);

    if (isMoviesLoading) {
      return const HomeSkeleton();
    }

    if (isMoviesError) {
      return ErrorView(
        message:
            'No se pudieron cargar las películas.\nRevisá tu conexión e intentá de nuevo.',
        onRetry: _retryAll,
      );
    }

    final nowPlayingState = ref.watch(nowPlayingMoviesProvider);
    final moviesSlideShow = ref.watch(moviesSlideShowProvider);
    final topRatedState = ref.watch(topRatedMoviesProvider);
    final upcomingState = ref.watch(upcomingMoviesProvider);

    final servedFromCache = nowPlayingState.fromCache ||
        topRatedState.fromCache ||
        upcomingState.fromCache;

    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          const SliverAppBar(
            floating: true,
            title: CustomAppBar(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 2),

              /// Aviso de contenido desde el caché (sin conexión)
              if (servedFromCache) const CachedContentBanner(),

              /// Movies SlideShow
              MoviesSlideShow(movies: moviesSlideShow),

              /// Movies Horizontal ListViews
              MoviesHorizontalListView(
                nowPlayingState,
                title: 'En cartelera',
                subtitle: HumanFormatter.currentDate(DateTime.now()),
                onLoadMore: () => unawaited(
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()),
              ),
              MoviesHorizontalListView(
                topRatedState,
                title: 'Mejor valoradas',
                onLoadMore: () => unawaited(
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage()),
              ),
              MoviesHorizontalListView(
                upcomingState,
                title: 'Próximamente',
                onLoadMore: () => unawaited(
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage()),
              ),
              const SizedBox(height: 10),
            ]),
          ),
        ],
      ),
    );
  }
}
