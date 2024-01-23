import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/src/features/anilist/application/anilist_service.dart';
import 'package:portfolio/src/features/anime/domain/media.dart';
import 'package:portfolio/src/features/anime/presentation/tierlist/anime_tierlist_card.dart';
import 'package:portfolio/src/l10n/app_localizations.dart';
import 'package:portfolio/src/utils/season.dart';
import 'package:portfolio/src/widgets/async_value_widget.dart';
import 'package:portfolio/src/widgets/info_label.dart';
import 'package:portfolio/styles.dart';

class AnimeTierListScreen extends ConsumerStatefulWidget {
  const AnimeTierListScreen({super.key});

  @override
  ConsumerState<AnimeTierListScreen> createState() => _AnimeTierListScreenState();
}

class _AnimeTierListScreenState extends ConsumerState<AnimeTierListScreen> {
  var _year = DateTime.now().year;
  var _season = DateTime.now().season;

  @override
  Widget build(BuildContext context) {
    const firstYear = 1939;
    final lastYear = DateTime.now().year + 1;
    final years = List<int>.generate(max(0, lastYear - firstYear), (index) => lastYear - index);

    final asyncAnime = ref.watch(browseAnimeProvider(season: _season, year: _year));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: InfoLabel(
                labelText: context.loc.anime_tierlist_year,
                child: DropdownButtonFormField(
                  value: _year,
                  items: years.map(_buildYear).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onYearChanged,
                ),
              ),
            ),
            Gaps.p8,
            Expanded(
              child: InfoLabel(
                labelText: context.loc.anime_tierlist_season,
                child: DropdownButtonFormField(
                  value: _season,
                  items: Season.values.sorted(Season.animeComparator).map(_buildSeason).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onSeasonChanged,
                ),
              ),
            ),
          ],
        ),
        Gaps.p12,
        Expanded(
          child: AsyncValueWidget(
            asyncAnime,
            data: (anime) => SingleChildScrollView(
              child: Wrap(
                spacing: Insets.p6,
                runSpacing: Insets.p6,
                children: anime.map(_buildItem).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<int> _buildYear(int year) {
    return DropdownMenuItem<int>(
      value: year,
      child: Text('$year'),
    );
  }

  DropdownMenuItem<Season> _buildSeason(Season season) {
    return DropdownMenuItem<Season>(
      value: season,
      child: Text(context.loc.season(season)),
    );
  }

  void _onYearChanged(int? value) {
    if (value != null) {
      setState(() {
        _year = value;
      });
    }
  }

  void _onSeasonChanged(Season? value) {
    if (value != null) {
      setState(() {
        _season = value;
      });
    }
  }

  Widget _buildItem(Media media) {
    return AnimeTierListCard(media);
  }
}
