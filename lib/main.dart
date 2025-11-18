
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/locale_repository.dart';
import 'localization/localization.dart';
import 'myapp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load JSON localization
  final localizationData = await loadLocalizationData();

  // Load locale lưu trong SharedPreferences
  final repo = LocaleRepository();
  final savedLocale = await repo.loadLocale();

  runApp(
    ProviderScope(
      overrides: [
        localizationMapProvider.overrideWithValue(AsyncData(localizationData)),
        localeProvider.overrideWith((ref) => savedLocale),
      ],
      child: const MyApp(),
    ),
  );
}
