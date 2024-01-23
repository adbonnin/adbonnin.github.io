import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/src/features/anilist/application/anilist_service.dart';
import 'package:portfolio/src/features/anime/domain/media.dart';
import 'package:portfolio/src/features/anime/presentation/tierlist/anime_tierlist_card.dart';
import 'package:portfolio/src/l10n/app_localizations.dart';
import 'package:portfolio/src/utils/season.dart';
import 'package:portfolio/src/widgets/async_value_widget.dart';
import 'package:portfolio/src/widgets/info_label.dart';
import 'package:portfolio/src/widgets/loading_icon.dart';
import 'package:portfolio/src/widgets/widgets_to_image.dart';
import 'package:portfolio/styles.dart';

class AnimeTierListScreen extends ConsumerStatefulWidget {
  const AnimeTierListScreen({super.key});

  @override
  ConsumerState<AnimeTierListScreen> createState() => _AnimeTierListScreenState();
}

class _AnimeTierListScreenState extends ConsumerState<AnimeTierListScreen> {
  var _exportingThumbnails = false;

  var _year = DateTime.now().year;
  var _season = DateTime.now().season;

  @override
  Widget build(BuildContext context) {
    const firstYear = 1939;
    final lastYear = DateTime.now().year + 1;
    final years = List<int>.generate(max(0, lastYear - firstYear), (index) => lastYear - index);

    final asyncAnime = ref.watch(browseAnimeProvider(season: _season, year: _year));
    final anime = asyncAnime.valueOrNull;
    final cannotExportThumbnails = anime == null || asyncAnime.isLoading || _exportingThumbnails;

    final imageControllers = List.generate(anime?.length ?? 0, (_) => WidgetsToImageController());

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
                  items: years //
                      .map(_buildYear)
                      .toList(),
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
                  items: Season.values //
                      .sorted(Season.animeComparator)
                      .map(_buildSeason)
                      .toList(),
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
            data: (anime) => ScrollShadow(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: Insets.p6,
                  runSpacing: Insets.p6,
                  children: anime //
                      .mapIndexed((index, element) => _buildItem(element, imageControllers[index]))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        Gaps.p12,
        Row(
          children: [
            FilledButton.icon(
              onPressed: cannotExportThumbnails ? null : () => _exportThumbnails(imageControllers),
              icon: LoadingIcon(Icons.download, loading: _exportingThumbnails),
              label: Text(_exportingThumbnails //
                  ? context.loc.anime_tierlist_exportingThumbnails
                  : context.loc.anime_tierlist_exportThumbnails),
            ),
          ],
        )
      ],
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

  Widget _buildItem(
    Media media,
    WidgetsToImageController imageController,
  ) {
    return WidgetsToImage(
      controller: imageController,
      child: AnimeTierListCard(media),
    );
  }

  Future<void> _exportThumbnails(List<WidgetsToImageController> imageControllers) async {
    setState(() {
      _exportingThumbnails = true;
    });

    try {
      final bytes = await _buildZip(imageControllers);

      await FileSaver.instance.saveFile(
        name: 'thumbnails.zip',
        bytes: bytes,
        ext: '.zip',
        mimeType: MimeType.zip,
      );
    } //
    finally {
      setState(() {
        _exportingThumbnails = false;
      });
    }
  }

  Future<Uint8List> _buildZip(List<WidgetsToImageController> imageControllers) async {
    final archive = Archive();
    final numberFormat = NumberFormat("000");

    for (var i = 0; i < imageControllers.length; i++) {
      final imageController = imageControllers[i];
      final image = await imageController.capture();

      if (image == null) {
        continue;
      }

      final file = ArchiveFile(
        '${numberFormat.format(i)}.png',
        image.lengthInBytes,
        image,
      );

      archive.addFile(file);
    }

    final outputStream = OutputStream(byteOrder: LITTLE_ENDIAN);
    final encoder = ZipEncoder();

    final bytes = encoder.encode(archive, output: outputStream)!;
    return Uint8List.fromList(bytes);
  }
}
