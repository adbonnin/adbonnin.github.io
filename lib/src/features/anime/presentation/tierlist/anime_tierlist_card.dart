import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/src/features/anime/domain/media.dart';

class AnimeTierListCard extends StatelessWidget {
  const AnimeTierListCard(
    this.media, {
    super.key,
  });

  final Media media;

  @override
  Widget build(BuildContext context) {
    final coverUrl = media.coverImageMedium;

    return SizedBox(
      width: 80,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: coverUrl == null
                  ? Image.asset(Images.anilistCoverMediumDefault)
                  : CachedNetworkImage(
                      imageUrl: coverUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Image.asset(Images.anilistCoverMediumDefault),
                      errorWidget: (_, __, ___) => Image.asset(Images.anilistCoverMediumDefault),
                    ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                color: const Color(0xE6292929),
                padding: const EdgeInsets.fromLTRB(3, 2, 3, 1),
                child: AutoSizeText(
                  media.englishTitle ?? media.userPreferredTitle ?? '',
                  style: GoogleFonts.overpass(
                    color: Colors.white,
                    height: 0,
                  ),
                  minFontSize: 0,
                  maxFontSize: 9,
                  maxLines: 5,
                  stepGranularity: 0.1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
