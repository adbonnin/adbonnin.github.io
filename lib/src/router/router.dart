import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/src/features/anime/presentation/tierlist/anime_tierlist_screen.dart';
import 'package:portfolio/src/router/main_shell_scaffold.dart';
import 'package:portfolio/src/features/home/presentation/home_screen.dart';
import 'package:portfolio/src/features/settings/presentation/settings_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  return GoRouter(
    routes: $appRoutes,
    initialLocation: const AnimeTierListRouteData().location,
    debugLogDiagnostics: true,
  );
}

// https://github.com/flutter/packages/blob/main/packages/go_router_builder/example/lib/stateful_shell_route_example.dart
// https://github.com/flutter/packages/blob/main/packages/go_router_builder/example/lib/stateful_shell_route_initial_location_example.dart
@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<AnimeTierListBranchData>(
      routes: [
        TypedGoRoute<AnimeTierListRouteData>(
          path: '/anime-tierlist',
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranchData>(
      routes: [
        TypedGoRoute<SettingsRouteData>(
          path: '/settings',
        ),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return MainShellScaffold(
      navigationShell: navigationShell,
    );
  }
}

class AnimeTierListBranchData extends StatefulShellBranchData {
  const AnimeTierListBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _homeNavigatorKey;
}

class SettingsBranchData extends StatefulShellBranchData {
  const SettingsBranchData();
}

class AnimeTierListRouteData extends GoRouteData {
  const AnimeTierListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AnimeTierListScreen();
  }
}

class SettingsRouteData extends GoRouteData {
  const SettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}
