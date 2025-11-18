import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization.dart';

extension LocalizationRef on WidgetRef {
  AppLocalizations get loc {
    final value = watch(localizationProvider);
    if (value == null) throw Exception('Localization not loaded');
    return value;
  }

  AppLocalizations? get locOrNull => watch(localizationProvider);

  String translate(String key, {String? fallback}) {
    return locOrNull?.translate(key, fallback: fallback) ?? fallback ?? key;
  }
}
