import 'package:flutter/widgets.dart';

class Interest {
  Interest({
    required this.name,
    required this.iconBuilder,
  });

  final String name;
  final WidgetBuilder iconBuilder;
}
