import 'package:flutter/material.dart';
import 'package:portfolio/styles.dart';

class InfoLabel extends StatelessWidget {
  const InfoLabel({
    super.key,
    required this.labelText,
    required this.child,
  });

  final String labelText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelText,
          style: textTheme.labelLarge,
        ),
        Gaps.p6,
        child,
      ],
    );
  }
}
