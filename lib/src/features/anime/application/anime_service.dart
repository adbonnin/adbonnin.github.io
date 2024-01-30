import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/src/features/anilist/application/anilist_service.dart';
import 'package:portfolio/src/features/anilist/data/browse_anime.graphql.dart';
import 'package:portfolio/src/features/anilist/data/schema.graphql.dart';
import 'package:portfolio/src/features/anime/domain/anime.dart';
import 'package:portfolio/src/features/anime/domain/anime_season.dart';
import 'package:portfolio/src/utils/iterable_extensions.dart';
import 'package:portfolio/src/utils/season.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anime_service.g.dart';

@Riverpod(keepAlive: true)
AnimeService animeService(AnimeServiceRef ref) {
  return AnimeService(ref);
}

class AnimeService {
  const AnimeService(this.ref);

  final Ref ref;

  Future<AnimeSeason> browseAnime(int year, Season season) async {
    final anilistService = ref.read(anilistServiceProvider);

    final anime = (await anilistService.browseAnime(year: year, season: season)) //
        .map((m) => m.toAnime())
        .whereNotNull();

    final leftovers = (await anilistService.browseLeftovers(year: year, season: season)) //
        .map((m) => m.toAnime())
        .whereNotNull();

    final leftoversWithoutSpecials = leftovers //
        .where((a) => a.format != AnimeFormat.ovaOnaSpecial);

    final leftoverSpecials = leftovers //
        .where((a) => a.format == AnimeFormat.ovaOnaSpecial);

    final allAnime = [anime, leftoverSpecials].flatten();

    return AnimeSeason(
      tv: allAnime.whereTv().toList(),
      tvShort: allAnime.whereTvShort().toList(),
      leftovers: leftoversWithoutSpecials.toList(),
      movie: allAnime.whereMovie().toList(),
      ovaOnaSpecial: allAnime.whereOvaOnaSpecial().toList(),
    );
  }
}

@riverpod
Future<AnimeSeason> browseAnime(BrowseAnimeRef ref, int year, Season season) {
  final service = ref.read(animeServiceProvider);
  return service.browseAnime(year, season);
}

extension _MediaExtension on Query$BrowseAnime$Page$media {
  Anime? toAnime() {
    final animeFormat = format?.toMediaFormat();

    if (animeFormat == null) {
      return null;
    }

    return Anime(
      id: id,
      englishTitle: title?.english ?? '',
      nativeTitle: title?.native ?? '',
      userPreferredTitle: title?.userPreferred ?? '',
      coverImageMedium: coverImage?.medium,
      format: animeFormat,
    );
  }
}

extension _Enum$MediaFormatExtension on Enum$MediaFormat {
  AnimeFormat? toMediaFormat() {
    return switch (this) {
      Enum$MediaFormat.MOVIE => AnimeFormat.movie,
      Enum$MediaFormat.ONA => AnimeFormat.ovaOnaSpecial,
      Enum$MediaFormat.OVA => AnimeFormat.ovaOnaSpecial,
      Enum$MediaFormat.SPECIAL => AnimeFormat.ovaOnaSpecial,
      Enum$MediaFormat.TV => AnimeFormat.tv,
      Enum$MediaFormat.TV_SHORT => AnimeFormat.tvShort,
      _ => null,
    };
  }
}
