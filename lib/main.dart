import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcase/pages/example1.dart';
import 'package:showcase/widgets/app.dart';
import 'package:showcase/widgets/page.dart';

void main() {
  final destinations = [
    Destination(
      title: 'Example1',
      route: '/example1',
      icon: const Icon(Icons.add),
      selectedIcon: const Icon(Icons.add),
      builder: (_, destination) => Example1(destination: destination),
    ),
  ];

  runApp(
    App(
      title: "Showcase",
      destinations: destinations,
      child: const Showcase(),
    ),
  );
}

class Showcase extends StatelessWidget {
  const Showcase({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = App.of(context);

    final Map<String, WidgetBuilder> routes = {
      for (var destination in app.destinations) //
        destination.route: (context) => destination.builder(context, destination),
    };

    final Map<TargetPlatform, PageTransitionsBuilder> pageTransitionsBuilders = {
      for (var e in const PageTransitionsTheme().builders.entries) //
        e.key: AppPageTransitionsBuilder(e.value),
    };

    return MaterialApp(
      title: app.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: pageTransitionsBuilders,
        ),
      ),
      initialRoute: app.destinations[0].route,
      routes: routes,
    );
  }
}
