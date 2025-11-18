import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/locale_repository.dart';
import 'localization/localization.dart';
import 'localization/providers/locale_provider.dart';
import 'myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localizationData = await loadLocalizationData();
  final repo = LocaleRepository();
  final savedLocale = await repo.loadLocale();

  runApp(
    ProviderScope(
      overrides: [
        localizationMapProvider.overrideWithValue(AsyncData(localizationData)),
        localeNotifierProvider.overrideWith(
          (ref) => LocaleNotifier(repo, savedLocale),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
