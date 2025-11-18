import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/localization.dart';

class LanguageSwitch extends ConsumerWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isEnglish = locale == 'en';

    return Switch(
      value: isEnglish,
      onChanged: (value) async {
        final newLocale = value ? 'en' : 'vi';
        // cập nhật Riverpod
        ref.read(localeProvider.notifier).state = newLocale;

        // lưu vào SharedPreferences
        final repo = ref.read(localeRepositoryProvider);
        await repo.saveLocale(newLocale);
      },
    );
  }
}