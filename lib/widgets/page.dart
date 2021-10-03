import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver();

bool isMobileLayout(BuildContext context) {
  return MediaQuery.of(context).size.width < 768;
}

typedef NavigateTo = void Function(BuildContext context, String route);

typedef AppPageBuilder = Widget Function(BuildContext context, AppPage page, List<AppPage> pages);

class AppPage {
  final String title;
  final String route;
  final Widget icon;
  final Widget selectedIcon;
  final AppPageBuilder builder;

  AppPage({
    required this.title,
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });
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
  final AppPage page;
  final List<AppPage> pages;
  final Widget body;
  final Widget? floatingActionButton;

  const AppScaffold({
    Key? key,
    required this.page,
    required this.pages,
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(page.title),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: AppDrawer(
        pages: pages,
        alwaysVisible: false,
      ),
    );
  }

  Widget buildDesktop() {
    return Scaffold(
      appBar: AppBar(
        title: Text(page.title),
      ),
      body: Row(
        children: [
          AppDrawer(
            pages: pages,
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
  final List<AppPage> pages;
  final bool alwaysVisible;

  const AppDrawer({
    Key? key,
    required this.pages,
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
    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...widget.pages.map(
                  (page) => AppDrawerButton.fromPage(
                    page: page,
                    navigateTo: _navigateTo,
                    selectedRoute: _selectedRoute,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateTo(BuildContext context, String route) async {
    if (widget.alwaysVisible) {
      Navigator.pop(context);
    }

    await Navigator.pushNamed(context, route);
  }
}

class AppDrawerButton extends StatelessWidget {
  final Widget icon;
  final Widget selectedIcon;
  final Widget title;
  final String route;
  final NavigateTo navigateTo;
  final String? selectedRoute;

  const AppDrawerButton({
    Key? key,
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.route,
    required this.navigateTo,
    required this.selectedRoute,
  }) : super(key: key);

  AppDrawerButton.fromPage({
    Key? key,
    required AppPage page,
    required this.navigateTo,
    required this.selectedRoute,
  })  : icon = page.icon,
        selectedIcon = page.selectedIcon,
        title = Text(page.title),
        route = page.route,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = selectedRoute == route;
    return ListTile(
      leading: selected ? selectedIcon : icon,
      title: title,
      onTap: () => navigateTo(context, route),
      selected: selected,
    );
  }
}
