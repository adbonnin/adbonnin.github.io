import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/src/features/anime/domain/anime.dart';
import 'package:portfolio/src/features/anime/presentation/cover_image.dart';

class AnimeTierListCard extends StatelessWidget {
  const AnimeTierListCard(
    this.anime, {
    super.key,
    this.onTap,
  });

  final Anime anime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = anime.coverImageMedium;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 120,
        child: Stack(
          children: [
            Positioned.fill(
              child: CoverImage(imageUrl: coverUrl),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                color: const Color(0xE6292929),
                padding: const EdgeInsets.fromLTRB(4, 3, 4, 2),
                child: AutoSizeText(
                  anime.title,
                  style: GoogleFonts.overpass(
                    color: Colors.white,
                    height: 0,
                  ),
                  minFontSize: 0,
                  maxFontSize: 9,
                  maxLines: 6,
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
