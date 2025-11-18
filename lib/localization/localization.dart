import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/locale_provider.dart';

class AppLocalizations {
  final String locale;
  final Map<String, dynamic> _strings;

  AppLocalizations(this.locale, this._strings);

  String translate(String key, {String? fallback}) {
    final keys = key.split('.');
    dynamic value = _strings;

    for (final k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return fallback ?? key; // 🔹 Trả về fallback nếu key không tồn tại
      }
    }
    return value.toString();
  }
}

Future<Map<String, Map<String, dynamic>>> loadLocalizationData() async {
  //thêm các tên file json ngôn ngữ khác ở đây
  const supportedLocales = ['en', 'vi'];
  final result = <String, Map<String, dynamic>>{};

  for (final locale in supportedLocales) {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/lang/json/$locale.json',
      );

      result[locale] = json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // File không tồn tại → bỏ qua nhưng app vẫn chạy
      debugPrint('⚠️ File localization không tồn tại: $locale.json');
      result[locale] = {}; // hoặc bỏ dòng này nếu không muốn thêm key rỗng
    }
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
