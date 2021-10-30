import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showcase/widgets/app.dart';
import 'package:showcase/widgets/selected_route.dart';

bool isMobileLayout(BuildContext context) {
  return getWindowType(context) < AdaptiveWindowType.medium;
}

class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  final PageTransitionsBuilder? defaultBuilder;

  AppPageTransitionsBuilder(this.defaultBuilder);

  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final mobileLayout = isMobileLayout(context);
    return mobileLayout && defaultBuilder != null //
        ? defaultBuilder!.buildTransitions(route, context, animation, secondaryAnimation, child)
        : child;
  }
}

class AppScaffold extends StatelessWidget {
  final Destination destination;
  final Widget body;
  final Widget? floatingActionButton;

  const AppScaffold({
    Key? key,
    required this.destination,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMobileLayout(context) //
        ? buildMobile()
        : buildDesktop();
  }

  Widget buildMobile() {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        title: Text(destination.title),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: SelectedRoute(
        builder: (context, route) => AppDrawer(
          alwaysVisible: false,
          selectedRoute: route,
        ),
      ),
    );
  }

  Widget buildDesktop() {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        automaticallyImplyLeading: false,
        title: Text(destination.title),
      ),
      body: Row(
        children: [
          SelectedRoute(
            builder: (context, route) => AppDrawer(
              alwaysVisible: true,
              selectedRoute: route,
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
              body: body,
              floatingActionButton: floatingActionButton,
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final bool alwaysVisible;
  final String? selectedRoute;

  const AppDrawer({
    Key? key,
    required this.alwaysVisible,
    required this.selectedRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = App.of(context);
    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (Destination destination in app.destinations) //
                  _buildDestinationListTile(context, destination)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationListTile(BuildContext context, Destination destination) {
    final selected = selectedRoute == destination.route;
    return ListTile(
      leading: selected ? destination.selectedIcon : destination.icon,
      title: Text(destination.title),
      onTap: () => _navigateTo(context, destination.route),
      selected: selected,
    );
  }

  Future<void> _navigateTo(BuildContext context, String route) async {
    if (alwaysVisible) {
      Navigator.pop(context);
    }

    await Navigator.pushNamed(context, route);
  }
}
