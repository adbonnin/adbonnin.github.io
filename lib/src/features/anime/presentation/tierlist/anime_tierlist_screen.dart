import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/src/features/anime/application/anime_service.dart';
import 'package:portfolio/src/features/anime/domain/anime.dart';
import 'package:portfolio/src/features/anime/domain/anime_preference.dart';
import 'package:portfolio/src/features/anime/presentation/tierlist/anime_tierlist_group.dart';
import 'package:portfolio/src/features/anime/presentation/tierlist_edit/anime_tierlist_edit_dialog.dart';
import 'package:portfolio/src/l10n/app_localizations.dart';
import 'package:portfolio/src/utils/anime.dart';
import 'package:portfolio/src/utils/iterable_extensions.dart';
import 'package:portfolio/src/utils/number.dart';
import 'package:portfolio/src/utils/season.dart';
import 'package:portfolio/src/utils/string_extension.dart';
import 'package:portfolio/src/widgets/async_value_widget.dart';
import 'package:portfolio/src/widgets/info_label.dart';
import 'package:portfolio/src/widgets/loading_icon.dart';
import 'package:portfolio/src/widgets/widget_to_image.dart';
import 'package:portfolio/styles.dart';

class AnimeTierListScreen extends ConsumerStatefulWidget {
  const AnimeTierListScreen({super.key});

  @override
  ConsumerState<AnimeTierListScreen> createState() => _AnimeTierListScreenState();
}

class _AnimeTierListScreenState extends ConsumerState<AnimeTierListScreen> {
  final _tvKey = GlobalKey<AnimeTierListGroupState>();
  final _tvShortKey = GlobalKey<AnimeTierListGroupState>();
  final _leftoverKey = GlobalKey<AnimeTierListGroupState>();
  final _movieKey = GlobalKey<AnimeTierListGroupState>();
  final _ovaOnaSpecialKey = GlobalKey<AnimeTierListGroupState>();

  var _exportingThumbnails = false;

  var _year = DateTime.now().year;
  var _season = DateTime.now().season;

  var _preferencesById = <int, AnimePreference>{};

  @override
  Widget build(BuildContext context) {
    const firstYear = 1939;
    final lastYear = DateTime.now().year + 1;
    final years = List<int>.generate(max(0, lastYear - firstYear), (index) => lastYear - index);

    final asyncSeason = ref.watch(browseAnimeProvider(_year, _season));
    final cannotExportThumbnails = !asyncSeason.hasValue || asyncSeason.isLoading || _exportingThumbnails;

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
                      .sorted(animeSeasonComparator)
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
            asyncSeason,
            data: (season) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (season.tv.isNotEmpty)
                    AnimeTierListGroup(
                      key: _tvKey,
                      groupText: context.loc.anime_tierlist_tv,
                      anime: season.tv.map(_applyPreference).toList(),
                      onItemTap: _onItemTap,
                    ),
                  if (season.tvShort.isNotEmpty)
                    AnimeTierListGroup(
                      key: _tvShortKey,
                      groupText: context.loc.anime_tierlist_tvShort,
                      anime: season.tvShort.map(_applyPreference).toList(),
                      onItemTap: _onItemTap,
                    ),
                  if (season.leftovers.isNotEmpty)
                    AnimeTierListGroup(
                      key: _leftoverKey,
                      groupText: context.loc.anime_tierlist_leftover,
                      anime: season.leftovers.map(_applyPreference).toList(),
                      onItemTap: _onItemTap,
                    ),
                  if (season.movie.isNotEmpty)
                    AnimeTierListGroup(
                      key: _movieKey,
                      groupText: context.loc.anime_tierlist_movie,
                      anime: season.movie.map(_applyPreference).toList(),
                      onItemTap: _onItemTap,
                    ),
                  if (season.ovaOnaSpecial.isNotEmpty)
                    AnimeTierListGroup(
                      key: _ovaOnaSpecialKey,
                      groupText: context.loc.anime_tierlist_ovaOnaSpecial,
                      anime: season.ovaOnaSpecial.map(_applyPreference).toList(),
                      onItemTap: _onItemTap,
                    ),
                ] //
                    .intersperse((_, __) => Gaps.p18)
                    .toList(),
              ),
            ),
          ),
        ),
        Gaps.p12,
        Row(
          children: [
            FilledButton.icon(
              onPressed: cannotExportThumbnails ? null : () => _exportThumbnails(context),
              icon: LoadingIcon(Icons.collections, loading: _exportingThumbnails),
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

  Future<void> _onItemTap(Anime anime) async {
    final updatedPreference = await showAnimeTierListEditDialog(
      context: context,
      anime: anime,
    );

    if (updatedPreference == null) {
      return;
    }

    final updatedPreferencesById = {
      ..._preferencesById,
      anime.id: updatedPreference,
    };

    setState(() {
      _preferencesById = updatedPreferencesById;
    });
  }

  Anime _applyPreference(Anime anime) {
    final preference = _preferencesById[anime.id];

    if (preference != null) {
      anime = anime.copyWith(
        customTitle: preference.customTitle,
        userSelectedTitle: preference.userSelectedTitle,
      );
    }

    return anime;
  }

  Future<void> _exportThumbnails(BuildContext context) async {
    setState(() {
      _exportingThumbnails = true;
    });

    try {
      final seasonLabel = context.loc.season(_season);

      final name = 'TierList $_year $seasonLabel';
      final bytes = await _buildZip();
      const ext = '.zip';
      const mimeType = MimeType.zip;

      if (bytes.isEmpty) {
        return;
      } //
      else if (kIsWeb) {
        await FileSaver.instance.saveFile(
          name: name,
          bytes: bytes,
          ext: ext,
          mimeType: mimeType,
        );
      } //
      else {
        final filePath = await FileSaver.instance.saveAs(
          name: name,
          bytes: bytes,
          ext: ext,
          mimeType: mimeType,
        );

        if (filePath != null) {
          await File(filePath).writeAsBytes(bytes);
        }
      }
    } //
    finally {
      setState(() {
        _exportingThumbnails = false;
      });
    }
  }

  Future<Uint8List> _buildZip() async {
    final archive = Archive();

    final keys = [
      _tvKey,
      _tvShortKey,
      _leftoverKey,
      _movieKey,
      _ovaOnaSpecialKey,
    ];

    final total = keys //
        .map<int>((key) => key.currentState?.imageControllers.length ?? 0)
        .sum;

    var offset = 1;

    for (final keys in keys) {
      final currentState = keys.currentState;

      if (currentState == null) {
        continue;
      }

      final groupText = currentState.widget.groupText //
          .removeSpecialCharacters()
          .removeMultipleSpace();

      final imageControllers = currentState.imageControllers;

      await _addCapturesToArchive(archive, total, offset, groupText, imageControllers);
      offset += imageControllers.length;
    }

    if (archive.isEmpty) {
      return Uint8List(0);
    }

    final outputStream = OutputStream(byteOrder: LITTLE_ENDIAN);
    final encoder = ZipEncoder();

    final bytes = encoder.encode(archive, output: outputStream)!;
    return Uint8List.fromList(bytes);
  }

  Future<void> _addCapturesToArchive(
    Archive archive,
    int total,
    int offset,
    String groupText,
    List<WidgetToImageController> imageControllers,
  ) async {
    if (imageControllers.isEmpty) {
      return;
    }

    final numberFormat = Numbers.numberFormatFromDigits(imageControllers.length);

    for (var i = 0; i < imageControllers.length; i++) {
      final imageController = imageControllers[i];
      final image = await imageController.capture();

      if (image == null) {
        continue;
      }

      final index = numberFormat.format(offset + i);

      final file = ArchiveFile(
        '$index $groupText.png',
        image.lengthInBytes,
        image,
      );

      archive.addFile(file);
    }
  }
}
