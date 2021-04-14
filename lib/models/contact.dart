import 'package:flutter/widgets.dart';

class Contact {
  Contact({
    required this.iconBuilder,
    required this.value,
    this.link = false
  });

  final WidgetBuilder iconBuilder;
  final String value;
  final bool link;
}
