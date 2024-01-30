import 'package:portfolio/src/features/anime/domain/anime.dart';

class AnimeSeason {
  const AnimeSeason({
    required this.tv,
    required this.tvShort,
    required this.leftovers,
    required this.movie,
    required this.ovaOnaSpecial,
  });

  final List<Anime> tv;
  final List<Anime> tvShort;
  final List<Anime> leftovers;
  final List<Anime> movie;
  final List<Anime> ovaOnaSpecial;

  int count() {
    return tv.length + //
        tvShort.length +
        leftovers.length +
        movie.length +
        ovaOnaSpecial.length;
  }
}
