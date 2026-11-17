import 'package:cinemapedia/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Señal de "se volvió a tocar el tab activo": cada pantalla la escucha para
/// volver al inicio de su lista.
final tabReselectProvider =
    StateProvider<({int index, int count})?>((ref) => null);

// Widget para manejar el scaffold con navegación adaptativa
class ScaffoldWithBottomNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    /// En tablets y escritorio (≥ Breakpoints.medium) se usa un NavigationRail
    /// en lugar de la barra inferior.
    if (width >= Breakpoints.medium) {
      final isExtended = width >= Breakpoints.expanded;

      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => _onTap(context, ref, index),
              extended: isExtended,
              labelType: isExtended ? null : NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: colors.primary),
              selectedLabelTextStyle: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home_outlined), label: Text('Inicio')),
                NavigationRailDestination(
                    icon: Icon(Icons.star_outline), label: Text('Populares')),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite_outline),
                    label: Text('Favoritos')),
                NavigationRailDestination(
                    icon: Icon(Icons.explore_outlined),
                    label: Text('Explorar')),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, ref, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'Populares',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    final isCurrentTab = index == navigationShell.currentIndex;

    if (isCurrentTab) {
      // Re-tocar el tab activo vuelve al inicio de su lista.
      ref.read(tabReselectProvider.notifier).update(
            (current) => (index: index, count: (current?.count ?? 0) + 1),
          );
    }

    navigationShell.goBranch(index, initialLocation: isCurrentTab);
  }
}
