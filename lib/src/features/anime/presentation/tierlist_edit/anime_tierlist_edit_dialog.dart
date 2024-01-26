import 'package:flutter/material.dart';
import 'package:portfolio/src/features/anime/domain/media.dart';
import 'package:portfolio/src/features/anime/presentation/tierlist_edit/anime_tierlist_edit_form.dart';
import 'package:portfolio/src/l10n/app_localizations.dart';

Future<Media?> showAnimeTierListEditDialog({
  required BuildContext context,
  required Media anime,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showDialog<Media>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    builder: (_) => AnimeTierListEditDialog(
      anime: anime,
    ),
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class AnimeTierListEditDialog extends StatefulWidget {
  const AnimeTierListEditDialog({
    super.key,
    required this.anime,
  });

  final Media anime;

  @override
  State<AnimeTierListEditDialog> createState() => _AnimeTierListEditDialogState();
}

class _AnimeTierListEditDialogState extends State<AnimeTierListEditDialog> {
  final _formKey = GlobalKey<AnimeTierListEditFormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.anime_tierlist_edit_title),
      content: AnimeTierListEditForm(
        key: _formKey,
        anime: widget.anime,
      ),
      actions: [
        OutlinedButton(
          onPressed: _onCancelPressed,
          child: Text(context.loc.common_cancel),
        ),
        FilledButton(
          onPressed: _onConfirmPressed,
          child: Text(context.loc.common_confirm),
        ),
      ],
    );
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  void _onConfirmPressed() {
    final formState = _formKey.currentState;

    if (formState == null) {
      return;
    }

    final value = formState.value();

    final updatedAnime = widget.anime.copyWith(
      userSelectedTitle: value.userSelectedTitle,
      customTitle: value.customTitle,
    );

    Navigator.of(context).pop(updatedAnime);
  }
}
