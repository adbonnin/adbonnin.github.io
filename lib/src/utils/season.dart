enum Season {
  spring,
  summer,
  fall,
  winter;

  Season get previous {
    return switch (this) {
      Season.spring => Season.winter,
      Season.summer => Season.spring,
      Season.fall => Season.summer,
      Season.winter => Season.fall,
    };
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
