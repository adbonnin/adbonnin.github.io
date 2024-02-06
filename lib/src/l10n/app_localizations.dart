import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizedBuildContextExtension on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this)!;
  }
}
