import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/src/features/anime/domain/anime.dart';
import 'package:portfolio/src/features/anime/presentation/tierlist/anime_tierlist_card.dart';
import 'package:portfolio/src/widgets/widget_to_image.dart';
import 'package:portfolio/styles.dart';

class AnimeTierListGroup extends StatefulWidget {
  const AnimeTierListGroup({
    super.key,
    required this.groupText,
    required this.anime,
    required this.onItemTap,
  });

  final String groupText;
  final List<Anime> anime;
  final ValueChanged<Anime> onItemTap;

  @override
  State<AnimeTierListGroup> createState() => AnimeTierListGroupState();
}

class AnimeTierListGroupState extends State<AnimeTierListGroup> {
  late List<WidgetToImageController> imageControllers;

  @override
  void initState() {
    super.initState();
    imageControllers = List.generate(widget.anime.length, (index) => WidgetToImageController());
  }

  @override
  void didUpdateWidget(AnimeTierListGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.anime.length != oldWidget.anime.length) {
      imageControllers = List.generate(widget.anime.length, (index) => WidgetToImageController());
    }
  }

  @override
  void dispose() {
    imageControllers = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.groupText,
          style: textTheme.headlineSmall,
        ),
        Gaps.p6,
        Wrap(
          spacing: Insets.p6,
          runSpacing: Insets.p6,
          children: widget.anime //
              .mapIndexed(_buildItem)
              .toList(),
        ),
      ],
    );
  }

  Widget _buildItem(int index, Anime anime) {
    return WidgetToImage(
      controller: imageControllers[index],
      child: AnimeTierListCard(
        anime,
        onTap: () => widget.onItemTap(anime),
      ),
    );
  }
}
