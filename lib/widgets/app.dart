import 'package:flutter/widgets.dart';

typedef PageBuilder = Widget Function(BuildContext context, Destination destination);

class App extends InheritedWidget {
  final String title;
  final List<Destination> destinations;

  const App({
    Key? key,
    required this.title,
    required this.destinations,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static App of(BuildContext context) {
    final App? result = context.dependOnInheritedWidgetOfExactType<App>();
    assert(result != null, 'No App found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(App oldWidget) {
    return title != oldWidget.title || //
        destinations != oldWidget.destinations;
  }
}

class Destination {
  final String title;
  final String route;
  final Widget icon;
  final Widget selectedIcon;
  final PageBuilder builder;

  Destination({
    required this.title,
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });
}
