import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio/src/widgets/widget_to_image.dart';

class WidgetToImageWrap extends StatefulWidget {
  const WidgetToImageWrap({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final double runSpacing;

  @override
  State<WidgetToImageWrap> createState() => WidgetToImageWrapState();
}

class WidgetToImageWrapState extends State<WidgetToImageWrap> {
  late List<WidgetToImageController> imageControllers;

  @override
  void initState() {
    super.initState();
    imageControllers = List.generate(widget.itemCount, (index) => WidgetToImageController());
  }

  @override
  void didUpdateWidget(WidgetToImageWrap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.itemCount != oldWidget.itemCount) {
      imageControllers = List.generate(widget.itemCount, (index) => WidgetToImageController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: List.generate(widget.itemCount, _buildItem),
    );
  }

  Widget _buildItem(int index) {
    return WidgetToImage(
      controller: imageControllers[index],
      child: widget.itemBuilder(context, index),
    );
  }
}
