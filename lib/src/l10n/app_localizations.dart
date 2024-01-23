import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:portfolio/src/utils/season.dart';

extension LocalizedBuildContextExtension on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this)!;
  }
}

extension AppLocalizationsExtension on AppLocalizations {
  String season(Season value) {
    return switch (value) {
      Season.spring => common_spring,
      Season.summer => common_summer,
      Season.fall => common_fall,
      Season.winter => common_winter,
    };
  }
}
