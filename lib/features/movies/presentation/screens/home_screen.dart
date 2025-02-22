import 'package:cinemapedia/common/widgets/custom_appbar.dart';
import 'package:cinemapedia/common/widgets/custom_bottom_navigation.dart';
import 'package:cinemapedia/common/widgets/full_screen_loader.dart';
import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:cinemapedia/features/movies/presentation/providers/is_movies_loading_provider.dart';
import 'package:cinemapedia/features/movies/presentation/providers/movies_provider.dart';
import 'package:cinemapedia/features/movies/presentation/providers/movies_slideshow_provider.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movies_horizontal_listview.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/movies_slideshow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  ConsumerState<_HomeView> createState() => __HomeViewState();
}

class __HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final isMoviesLoading = ref.watch(isMoviesLoadingProvider);

    if (isMoviesLoading) {
      return FullScreenLoader();
    }

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final moviesSlideShow = ref.watch(moviewsSlideShowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true, // Indica si el appbar debe ser flotante.
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              alignment: Alignment.center,
              child: const CustomAppBar(),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              children: [
                // const CustomAppBar(),
                const SizedBox(height: 2),
                MoviesSlideShow(movies: moviesSlideShow),
                MoviesHorizontalListView(
                  nowPlayingMovies,
                  title: 'En cartelera',
                  subtitle: HumanFormatter.currentDa(DateTime.now()),
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
                MoviesHorizontalListView(
                  popularMovies,
                  title: 'Populares',
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
                MoviesHorizontalListView(
                  topRatedMovies,
                  title: 'Mejor valoradas',
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),
                MoviesHorizontalListView(
                  upcomingMovies,
                  title: 'Próximamente',
                  loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),
                const SizedBox(height: 10),
              ],
            )
          ]),
        ),
      ],
    );
  }
}
