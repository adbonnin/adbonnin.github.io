class Media {
  Media({
    this.englishTitle,
    this.nativeTitle,
    this.userPreferredTitle,
    this.coverImageMedium,
    this.format,
  });

  final String? englishTitle;
  final String? nativeTitle;
  final String? userPreferredTitle;
  final String? coverImageMedium;
  final MediaFormat? format;
}

enum MediaFormat {
  manga,
  movie,
  music,
  novel,
  ona,
  oneShot,
  ova,
  special,
  tv,
  tvShort,
  $unknown,
}
