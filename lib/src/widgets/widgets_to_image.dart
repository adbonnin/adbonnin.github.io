import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WidgetsToImage extends StatelessWidget {
  const WidgetsToImage({
    super.key,
    required this.controller,
    required this.child,
  });

  final WidgetsToImageController controller;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.containerKey,
      child: child,
    );
  }
}

class WidgetsToImageController {
  final containerKey = GlobalKey();

  Future<Uint8List?> capture() async {
    final boundary = containerKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      return null;
    }

    final image = await boundary.toImage(pixelRatio: 1);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
