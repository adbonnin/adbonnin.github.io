enum Season {
  spring(animeOrder: 1),
  summer(animeOrder: 2),
  fall(animeOrder: 3),
  winter(animeOrder: 0);

  const Season({required this.animeOrder});

  final int animeOrder;

  Season get previous {
    return switch (this) {
      Season.spring => Season.winter,
      Season.summer => Season.spring,
      Season.fall => Season.summer,
      Season.winter => Season.fall,
    };
  }

  int previousYear(int year) {
    return year - (this == Season.winter ? 1 : 0);
  }

  static int animeComparator(Season a, Season b) {
    return a.animeOrder - b.animeOrder;
  }
}

extension DateTimeExtension on DateTime {
  Season get season {
    if (isBefore(DateTime(year, 3, 21))) {
      return Season.winter;
    }

    if (isBefore(DateTime(year, 6, 21))) {
      return Season.spring;
    }

    if (isBefore(DateTime(year, 9, 23))) {
      return Season.summer;
    }

    if (isBefore(DateTime(year, 12, 21))) {
      return Season.fall;
    }

    return Season.winter;
  }
}
