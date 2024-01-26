import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WidgetToImage extends StatelessWidget {
  const WidgetToImage({
    super.key,
    required this.controller,
    required this.child,
  });

  final WidgetToImageController controller;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.containerKey,
      child: child,
    );
  }
}

class WidgetToImageController {
  final containerKey = GlobalKey();

  Future<Uint8List?> capture() async {
    final renderObject = containerKey.currentContext?.findRenderObject();
    final boundary = renderObject as RenderRepaintBoundary?;

    if (boundary == null) {
      return null;
    }

    final image = await boundary.toImage(pixelRatio: 1);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
