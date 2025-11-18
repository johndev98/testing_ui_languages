import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/providers/locale_provider.dart';

class LanguageSwitch extends ConsumerWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    return Switch(
      value: locale == 'en',
      onChanged: (v) {
        ref.read(localeNotifierProvider.notifier).setLocale(v ? 'en' : 'vi');
      },
    );
  }
}
