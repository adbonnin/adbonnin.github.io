import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:showcase/widgets/page.dart';

class Example1 extends StatelessWidget {
  final AppPage page;
  final List<AppPage> pages;

  const Example1({
    Key? key,
    required this.page,
    required this.pages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      page: page,
      pages: pages,
      body: const Center(
        child: Text("Example 1"),
      ),
    );
  }
}
