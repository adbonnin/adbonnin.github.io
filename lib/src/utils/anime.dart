import 'package:portfolio/src/utils/season.dart';

int animeSeasonComparator(Season a, Season b) {
  return a.animeOrder - b.animeOrder;
}

extension AnimeSeasonExtension on Season {
  int previousAnimeYear(int year) {
    return year - (this == Season.winter ? 1 : 0);
  }

  int get animeOrder {
    return switch (this) {
      Season.spring => 1,
      Season.summer => 2,
      Season.fall => 3,
      Season.winter => 0,
    };
  }
}
