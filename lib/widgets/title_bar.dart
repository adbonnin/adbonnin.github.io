import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  final String title;

  const TitleBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = AppBarTheme.of(context);

    final toolbarHeight = appBarTheme.toolbarHeight ?? kToolbarHeight;
    final titleTextStyle = theme.primaryTextTheme.headline6?.copyWith(color: Colors.black);

    return SizedBox(
      height: toolbarHeight,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: titleTextStyle,
        ),
      ),
    );
  }
}
