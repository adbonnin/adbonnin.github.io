import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef RouteWidgetBuilder = Widget Function(BuildContext context, String? route);

class SelectedRoute extends StatefulWidget {
  final RouteWidgetBuilder builder;

  const SelectedRoute({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<SelectedRoute> createState() => _SelectedRouteState();
}

class _SelectedRouteState extends State<SelectedRoute> with RouteAware {
  late SelectedRouteObserver _routeObserver;

  String? _selectedRoute;

  @override
  void initState() {
    super.initState();
    _routeObserver = SelectedRouteObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPopNext() {
    _updateSelectedRoute();
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context)!.settings.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selectedRoute);
  }
}

class SelectedRouteObserver extends RouteObserver<ModalRoute<void>> {
  factory SelectedRouteObserver() => _instance;

  SelectedRouteObserver._private();

  static final SelectedRouteObserver _instance = SelectedRouteObserver._private();
}
