import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showcase/widgets/app.dart';
import 'package:showcase/widgets/app_scaffold.dart';

class Example2 extends StatelessWidget {
  final Destination destination;

  const Example2({
    Key? key,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      destination: destination,
      body: Center(
        child: Text(destination.title),
      ),
    );
  }
}
