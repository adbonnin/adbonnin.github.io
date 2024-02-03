import 'package:collection/collection.dart';
import 'package:graphql/client.dart';
import 'package:portfolio/src/features/anilist/data/browse_anime.graphql.dart';
import 'package:portfolio/src/features/anilist/data/schema.graphql.dart';
import 'package:portfolio/src/utils/anime.dart';
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

  Future<Iterable<Query$BrowseAnime$Page$media>> browseLeftovers({
    required int year,
    required Season season,
  }) {
    return browseAnime(
      year: season.previousAnimeYear(year),
      season: season.previous,
      episodeGreeter: 16,
    );
  }

  Future<Iterable<Query$BrowseAnime$Page$media>> browseAnime({
    int? year,
    Season? season,
    int? episodeGreeter,
  }) async {
    final pages = <Iterable<Query$BrowseAnime$Page$media>>[];
    bool hasNextPage = true;

    while (hasNextPage) {
      final result = await client.query$BrowseAnime(
        Options$Query$BrowseAnime(
          variables: Variables$Query$BrowseAnime(
            page: pages.length + 1,
            seasonYear: year,
            season: season?.toEnum$MediaSeason(),
            episodeGreater: episodeGreeter,
          ),
        ),
      );

      final page = result.parsedData?.Page;
      final media = page?.media ?? [];

      pages.add(media.whereNotNull());
      hasNextPage = (page?.pageInfo?.hasNextPage ?? false) || media.isNotEmpty;
    }

    return pages.flatten();
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
