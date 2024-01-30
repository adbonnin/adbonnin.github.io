import 'package:portfolio/src/features/anime/domain/anime.dart';

class AnimePreference {
  const AnimePreference({
    required this.customTitle,
    required this.userSelectedTitle,
  });

  final String customTitle;
  final MediaTitle userSelectedTitle;
}
