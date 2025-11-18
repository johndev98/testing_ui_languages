import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/locale_provider.dart';

class AppLocalizations {
  final String locale;
  final Map<String, dynamic> _strings;

  AppLocalizations(this.locale, this._strings);

  String translate(String key) {
    final parts = key.split('.');
    dynamic value = _strings;

    for (final p in parts) {
      if (value is Map<String, dynamic> && value.containsKey(p)) {
        value = value[p];
      } else {
        return key;
      }
    }
    return value.toString();
  }
}

Future<Map<String, Map<String, dynamic>>> loadLocalizationData() async {
  const supportedLocales = ['en', 'vi'];
  final result = <String, Map<String, dynamic>>{};

  for (final locale in supportedLocales) {
    final jsonString = await rootBundle.loadString(
      'assets/lang/json/$locale.json',
    );
    result[locale] = json.decode(jsonString) as Map<String, dynamic>;
  }

  return result;
}

final localizationMapProvider =
    FutureProvider<Map<String, Map<String, dynamic>>>(
      (ref) => throw UnimplementedError(),
    );

final localizationProvider = Provider<AppLocalizations?>((ref) {
  final asyncMap = ref.watch(localizationMapProvider);
  final locale = ref.watch(localeNotifierProvider);

  return asyncMap.when(
    data: (map) {
      final strings = map[locale] ?? map['en']!;
      return AppLocalizations(locale, strings);
    },
    loading: () => null,
    error: (_, _) => null,
  );
});
