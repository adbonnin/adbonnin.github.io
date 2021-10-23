import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showcase/widgets/app.dart';
import 'package:showcase/widgets/page.dart';

class Example1 extends StatelessWidget {
  final Destination destination;

  const Example1({
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
