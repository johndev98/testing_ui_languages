import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'locale_repository.dart';

class AppLocalizations {
  final String locale;
  final Map<String, dynamic> _strings;

  AppLocalizations(this.locale, this._strings);

  String translate(String key) {
    final keys = key.split('.');
    dynamic value = _strings;

    for (final k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return key;
      }
    }
    return value.toString();
  }
}

Future<Map<String, Map<String, dynamic>>> loadLocalizationData() async {
  const supportedLocales = ['en', 'vi'];
  final map = <String, Map<String, dynamic>>{};

  for (final locale in supportedLocales) {
    final jsonString = await rootBundle.loadString(
      'assets/lang/json/$locale.json',
    );
    map[locale] = json.decode(jsonString);
  }

  return map;
}
final localizationMapProvider =
    FutureProvider<Map<String, Map<String, dynamic>>>(
      (ref) async => throw UnimplementedError(
        'Localization map must be overridden in main()',
      ),
    );

final localeProvider = StateProvider<String>((ref) => 'vi');

final localeRepositoryProvider = Provider((ref) => LocaleRepository());

final localizationProvider = Provider<AppLocalizations?>((ref) {
  final asyncMap = ref.watch(localizationMapProvider);

  return asyncMap.when(
    data: (map) {
      final locale = ref.watch(localeProvider);
      final strings = map[locale] ?? map['en'];
      return strings == null ? null : AppLocalizations(locale, strings);
    },
    loading: () => null,
    error: (_, _) => null,
  );
});

