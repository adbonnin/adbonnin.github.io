import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showcase/widgets/app.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver();

bool isMobileLayout(BuildContext context) {
  return MediaQuery.of(context).size.width < 768;
}

typedef NavigateTo = void Function(BuildContext context, String route);

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
      drawer: const AppDrawer(
        alwaysVisible: false,
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
          const AppDrawer(
            alwaysVisible: true,
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

class AppDrawer extends StatefulWidget {
  final bool alwaysVisible;

  const AppDrawer({
    Key? key,
    required this.alwaysVisible,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
  late String? _selectedRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  void _updateSelectedRoute() {
    final route = ModalRoute.of(context)?.settings.name;
    if (route != null) {
      setState(() => _selectedRoute = route);
    }
  }

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
    final selected = _selectedRoute == destination.route;
    return ListTile(
      leading: selected ? destination.selectedIcon : destination.icon,
      title: Text(destination.title),
      onTap: () => _navigateTo(context, destination.route),
      selected: selected,
    );
  }

  Future<void> _navigateTo(BuildContext context, String route) async {
    if (widget.alwaysVisible) {
      Navigator.pop(context);
    }

    await Navigator.pushNamed(context, route);
  }
}
