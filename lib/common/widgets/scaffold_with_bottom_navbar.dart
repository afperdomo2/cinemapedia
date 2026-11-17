import 'package:cinemapedia/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Widget para manejar el scaffold con bottom navigation bar
class ScaffoldWithBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    /// En tablets y escritorio (≥ Breakpoints.medium) se usa un NavigationRail
    /// en lugar del BottomNavigationBar.
    if (width >= Breakpoints.medium) {
      final isExtended = width >= Breakpoints.expanded;

      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => _onTap(context, index),
              extended: isExtended,
              labelType: isExtended ? null : NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: colors.primary),
              selectedLabelTextStyle: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home_max), label: Text('Inicio')),
                NavigationRailDestination(icon: Icon(Icons.star_outline), label: Text('Populares')),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite_outline), label: Text('Favoritos')),
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
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: colors.primary,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(label: 'Inicio', icon: Icon(Icons.home_max)),
          BottomNavigationBarItem(label: 'Populares', icon: Icon(Icons.star_outline)),
          BottomNavigationBarItem(label: 'Favoritos', icon: Icon(Icons.favorite_outline)),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}
