import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/constants.dart';
import 'localization/locale_repository.dart';
import 'localization/localization.dart';
import 'localization/providers/locale_provider.dart';
import 'onboarding/services/isar_service.dart';
import 'myapp.dart';

// lấy ngôn ngữ hệ thống làm mặc định khi mở app đầu tiền.
String detectSystemLocale(List<String> supportedLocales) {
  final systemLocale = PlatformDispatcher.instance.locale.languageCode;
  if (supportedLocales.contains(systemLocale)) {
    return systemLocale;
  }
  // nếu ngôn ngữ hệ thông không có trong list ngôn ngữ của app thì mặc định trả về 'en'
  return 'en'; // fallback
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load user profile to ensure router has correct initial location
  await IsarService.openDB();
  
  final localizationData = await loadLocalizationData();
  final repo = LocaleRepository();
  final savedLocale = await repo.loadLocale();

  // nếu chưa có savedLocale thì detect hệ thống
  final defaultLocale = savedLocale ?? detectSystemLocale(supportedLocales);
  runApp(
    ProviderScope(
      overrides: [
        localizationMapProvider.overrideWith((ref) => localizationData),
        localeNotifierProvider.overrideWith(
          (ref) => LocaleNotifier(repo, defaultLocale),
        ),
      ],
      child: const MyApp(),
    ),
  );
}