import 'package:flutter/material.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/bloc/nav_cubit.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unselected = scheme.onSurfaceVariant.withValues(alpha: 0.85);
    const selected = Colors.white;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? selected
              : unselected;
          return IconThemeData(color: color);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? selected
              : unselected;
          return TextStyle(color: color);
        }),
      ),
      child: NavigationBar(
        selectedIndex: currentTab.index,
        onDestinationSelected: (index) => onTabSelected(HomeTab.values[index]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Characters',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
