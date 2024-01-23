import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/src/l10n/app_localizations.dart';

class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return AdaptiveScaffold(
      internalAnimations: false,
      selectedIndex: currentIndex,
      onSelectedIndexChange: _onSelectedIndexChange,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.collections_outlined),
          selectedIcon: const Icon(Icons.collections),
          label: context.loc.anime_title,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: context.loc.settings_title,
        ),
      ],
      body: (_) => Padding(
        padding: const EdgeInsets.all(12),
        child: navigationShell,
      ),
      useDrawer: false,
    );
  }

  void _onSelectedIndexChange(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}
