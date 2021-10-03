import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcase/pages/example1.dart';
import 'package:showcase/widgets/page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = <AppPage>[
      AppPage(
        title: 'Example1',
        route: '/example1',
        icon: const Icon(Icons.add),
        selectedIcon: const Icon(Icons.add),
        builder: (context, page, pages) => Example1(page: page, pages: pages),
      ),
    ];

    final Map<String, WidgetBuilder> routes = {
      for (var page in pages) page.route: (context) => page.builder(context, page, pages),
    };

    final Map<TargetPlatform, PageTransitionsBuilder> pageTransitionsBuilders = {
      for (var e in const PageTransitionsTheme().builders.entries) e.key: AppPageTransitionsBuilder(e.value),
    };

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: pageTransitionsBuilders,
        ),
      ),
      initialRoute: pages[0].route,
      routes: routes,
    );
  }
}
