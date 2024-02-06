import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio/assets.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Image.asset(Images.anilistCoverMediumDefault)
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) => Image.asset(Images.anilistCoverMediumDefault),
            errorWidget: (_, __, ___) => Image.asset(Images.anilistCoverMediumDefault),
          );
  }
}
