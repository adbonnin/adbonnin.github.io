import 'package:collection/collection.dart';
import 'package:graphql/client.dart';
import 'package:portfolio/src/features/anilist/data/browse_anime.graphql.dart';
import 'package:portfolio/src/features/anilist/data/schema.graphql.dart';
import 'package:portfolio/src/features/anime/domain/media.dart';
import 'package:portfolio/src/utils/iterable_extensions.dart';
import 'package:portfolio/src/utils/season.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'anilist_service.g.dart';

@Riverpod(keepAlive: true)
AnilistService anilistService(AnilistServiceRef ref) {
  final client = GraphQLClient(
    link: HttpLink('https://graphql.anilist.co'),
    cache: GraphQLCache(),
  );

  return AnilistService(client);
}

class AnilistService {
  const AnilistService(this.client);

  final GraphQLClient client;

  Future<List<Media>> browseAnime(
    int? year,
    Season? season,
    List<MediaFormat>? formats,
  ) async {
    final pages = <Iterable<Query$BrowseAnime$Page$media>>[];
    bool hasNextPage = true;

    while (hasNextPage) {
      final result = await client.query$BrowseAnime(
        Options$Query$BrowseAnime(
          variables: Variables$Query$BrowseAnime(
            page: pages.length + 1,
            seasonYear: year,
            season: season?.toEnum$MediaSeason(),
            format: formats?.map((mf) => mf.toEnum$MediaFormat()).toList(),
          ),
        ),
      );

      final page = result.parsedData?.Page;
      final media = page?.media ?? [];

      pages.add(media.whereNotNull());
      hasNextPage = (page?.pageInfo?.hasNextPage ?? false) || media.isNotEmpty;
    }

    return pages.flatten().map((e) => e.toMedia()).toList();
  }
}

@riverpod
Future<List<Media>> browseAnime(
  BrowseAnimeRef ref, {
  int? year,
  Season? season,
  List<MediaFormat>? formats,
}) {
  final service = ref.read(anilistServiceProvider);
  return service.browseAnime(year, season, formats);
}

extension _MediaExtension on Query$BrowseAnime$Page$media {
  Media toMedia() {
    return Media(
      englishTitle: title?.english,
      nativeTitle: title?.native,
      userPreferredTitle: title?.userPreferred,
      coverImageMedium: coverImage?.medium,
      format: format?.toMediaFormat(),
    );
  }
}

extension _SeasonExtension on Season {
  Enum$MediaSeason toEnum$MediaSeason() {
    return switch (this) {
      Season.winter => Enum$MediaSeason.WINTER,
      Season.spring => Enum$MediaSeason.SPRING,
      Season.summer => Enum$MediaSeason.SUMMER,
      Season.fall => Enum$MediaSeason.FALL,
    };
  }
}

extension _MediaFormatExtension on MediaFormat {
  Enum$MediaFormat toEnum$MediaFormat() {
    return switch (this) {
      MediaFormat.manga => Enum$MediaFormat.MANGA,
      MediaFormat.movie => Enum$MediaFormat.MOVIE,
      MediaFormat.music => Enum$MediaFormat.MUSIC,
      MediaFormat.novel => Enum$MediaFormat.NOVEL,
      MediaFormat.ona => Enum$MediaFormat.ONA,
      MediaFormat.oneShot => Enum$MediaFormat.ONE_SHOT,
      MediaFormat.ova => Enum$MediaFormat.OVA,
      MediaFormat.special => Enum$MediaFormat.SPECIAL,
      MediaFormat.tv => Enum$MediaFormat.TV,
      MediaFormat.tvShort => Enum$MediaFormat.TV_SHORT,
      MediaFormat.$unknown => Enum$MediaFormat.$unknown,
    };
  }
}

extension _Enum$MediaFormatExtension on Enum$MediaFormat {
  MediaFormat toMediaFormat() {
    return switch (this) {
      Enum$MediaFormat.MANGA => MediaFormat.manga,
      Enum$MediaFormat.MOVIE => MediaFormat.movie,
      Enum$MediaFormat.MUSIC => MediaFormat.music,
      Enum$MediaFormat.NOVEL => MediaFormat.novel,
      Enum$MediaFormat.ONA => MediaFormat.ona,
      Enum$MediaFormat.ONE_SHOT => MediaFormat.oneShot,
      Enum$MediaFormat.OVA => MediaFormat.ova,
      Enum$MediaFormat.SPECIAL => MediaFormat.special,
      Enum$MediaFormat.TV => MediaFormat.tv,
      Enum$MediaFormat.TV_SHORT => MediaFormat.tvShort,
      Enum$MediaFormat.$unknown => MediaFormat.$unknown,
    };
  }
}
