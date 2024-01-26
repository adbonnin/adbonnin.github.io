class Media {
  Media({
    required this.id,
    this.englishTitle = '',
    this.nativeTitle = '',
    this.userPreferredTitle = '',
    this.customTitle = '',
    this.userSelectedTitle,
    this.coverImageMedium,
    required this.format,
  });

  final int id;
  final String englishTitle;
  final String nativeTitle;
  final String userPreferredTitle;
  final String customTitle;
  final MediaTitle? userSelectedTitle;
  final String? coverImageMedium;
  final MediaFormat format;

  MediaTitle get selectedTitle {
    if (userSelectedTitle != null) {
      return userSelectedTitle!;
    }

    if (englishTitle.isNotEmpty) {
      return MediaTitle.english;
    }

    if (userPreferredTitle.isNotEmpty) {
      return MediaTitle.userPreferred;
    }

    if (nativeTitle.isNotEmpty) {
      return MediaTitle.native;
    }

    return MediaTitle.english;
  }

  String get title {
    return switch (selectedTitle) {
      MediaTitle.english => englishTitle,
      MediaTitle.native => nativeTitle,
      MediaTitle.userPreferred => userPreferredTitle,
      MediaTitle.custom => customTitle,
    };
  }

  Media copyWith({
    int? id,
    String? englishTitle,
    String? nativeTitle,
    String? userPreferredTitle,
    String? customTitle,
    MediaTitle? userSelectedTitle,
    String? coverImageMedium,
    MediaFormat? format,
  }) {
    return Media(
      id: id ?? this.id,
      englishTitle: englishTitle ?? this.englishTitle,
      nativeTitle: nativeTitle ?? this.nativeTitle,
      userPreferredTitle: userPreferredTitle ?? this.userPreferredTitle,
      customTitle: customTitle ?? this.customTitle,
      userSelectedTitle: userSelectedTitle ?? this.userSelectedTitle,
      coverImageMedium: coverImageMedium ?? this.coverImageMedium,
      format: format ?? this.format,
    );
  }
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

enum MediaTitle {
  english,
  native,
  userPreferred,
  custom,
}
