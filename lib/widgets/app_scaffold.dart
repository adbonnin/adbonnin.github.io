import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showcase/widgets/app.dart';
import 'package:showcase/widgets/selected_route.dart';
import 'package:showcase/widgets/title_bar.dart';

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
    final app = App.of(context);

    return isMobileLayout(context) //
        ? buildMobile()
        : buildDesktop(app);
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

  Widget buildDesktop(App app) {
    return Row(
      children: [
        SelectedRoute(
          builder: (context, route) => AppDrawer(
            alwaysVisible: true,
            selectedRoute: route,
            header: TitleBar(
              title: app.title,
            ),
          ),
        ),
        const VerticalDivider(
          width: 1,
          thickness: 1,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              primary: true,
              automaticallyImplyLeading: false,
              title: Text(destination.title),
            ),
            body: body,
            floatingActionButton: floatingActionButton,
          ),
        ),
      ],
    );
  }
}

class AppDrawer extends StatelessWidget {
  final bool alwaysVisible;
  final String? selectedRoute;
  final Widget? header;

  const AppDrawer({
    Key? key,
    this.header,
    required this.alwaysVisible,
    required this.selectedRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = App.of(context);
    return Drawer(
      child: Column(
        children: [
          if (header != null) header!,
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
