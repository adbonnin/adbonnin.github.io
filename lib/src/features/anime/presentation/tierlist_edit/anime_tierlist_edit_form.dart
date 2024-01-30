import 'package:flutter/material.dart';
import 'package:portfolio/src/features/anime/domain/anime.dart';
import 'package:portfolio/src/l10n/app_localizations.dart';
import 'package:portfolio/src/widgets/info_label.dart';
import 'package:portfolio/styles.dart';

class AnimeTierListEditFormData {
  const AnimeTierListEditFormData({
    required this.userSelectedTitle,
    required this.customTitle,
  });

  final MediaTitle userSelectedTitle;
  final String customTitle;
}

class AnimeTierListEditForm extends StatefulWidget {
  const AnimeTierListEditForm({
    super.key,
    required this.anime,
  });

  final Anime anime;

  @override
  State<AnimeTierListEditForm> createState() => AnimeTierListEditFormState();
}

class AnimeTierListEditFormState extends State<AnimeTierListEditForm> {
  final _customTitleController = TextEditingController();
  final _customTitleFocusNode = FocusNode();

  late MediaTitle _userSelectedTitle;

  @override
  void initState() {
    super.initState();
    _userSelectedTitle = widget.anime.selectedTitle;
    _customTitleFocusNode.addListener(_handleCustomTitleFocus);
  }

  @override
  void dispose() {
    _customTitleFocusNode.dispose();
    _customTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Form(
        child: InfoLabel(
          labelText: context.loc.anime_tierlist_edit_titleLabel,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.anime.englishTitle.isNotEmpty)
                AnimeTiersListTitleRadioListTile(
                  value: MediaTitle.english,
                  groupValue: _userSelectedTitle,
                  onChanged: _onUserSelectedTitleChanged,
                  titleText: context.loc.anime_title_english,
                  subtitle: Text(
                    widget.anime.englishTitle,
                    maxLines: null,
                  ),
                  onCopyPressed: () => _onCopyPressed(widget.anime.englishTitle),
                ),
              if (widget.anime.nativeTitle.isNotEmpty)
                AnimeTiersListTitleRadioListTile(
                  value: MediaTitle.native,
                  groupValue: _userSelectedTitle,
                  onChanged: _onUserSelectedTitleChanged,
                  titleText: context.loc.anime_title_native,
                  subtitle: Text(
                    widget.anime.nativeTitle,
                    maxLines: null,
                  ),
                  onCopyPressed: () => _onCopyPressed(widget.anime.nativeTitle),
                ),
              if (widget.anime.userPreferredTitle.isNotEmpty)
                AnimeTiersListTitleRadioListTile(
                  value: MediaTitle.userPreferred,
                  groupValue: _userSelectedTitle,
                  onChanged: _onUserSelectedTitleChanged,
                  titleText: context.loc.anime_title_userPreferred,
                  subtitle: Text(
                    widget.anime.userPreferredTitle,
                    maxLines: null,
                  ),
                  onCopyPressed: () => _onCopyPressed(widget.anime.userPreferredTitle),
                ),
              AnimeTiersListTitleRadioListTile(
                value: MediaTitle.custom,
                groupValue: _userSelectedTitle,
                onChanged: _onUserSelectedTitleChanged,
                titleText: context.loc.anime_title_custom,
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: Insets.p2),
                  child: TextFormField(
                    focusNode: _customTitleFocusNode,
                    controller: _customTitleController,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCustomTitleFocus() {
    if (_customTitleFocusNode.hasFocus) {
      setState(() {
        _userSelectedTitle = MediaTitle.custom;
      });
    }
  }

  void _onCopyPressed(String? text) {
    if (text != null) {
      _customTitleController.text = text;

      setState(() {
        _userSelectedTitle = MediaTitle.custom;
      });
    }
  }

  void _onUserSelectedTitleChanged(MediaTitle? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _userSelectedTitle = value;
    });
  }

  AnimeTierListEditFormData value() {
    return AnimeTierListEditFormData(
      userSelectedTitle: _userSelectedTitle,
      customTitle: _customTitleController.text,
    );
  }
}

class AnimeTiersListTitleRadioListTile<T> extends StatelessWidget {
  const AnimeTiersListTitleRadioListTile({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.onCopyPressed,
    required this.titleText,
    required this.subtitle,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onCopyPressed;
  final String titleText;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            title: Text(titleText),
            subtitle: subtitle,
            dense: true,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
          ),
        ),
        if (onCopyPressed != null) ...[
          Gaps.p6,
          IconButton.outlined(
            onPressed: onCopyPressed,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ],
    );
  }
}
