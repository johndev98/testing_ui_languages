import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/providers/locale_provider.dart';

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    return DropdownButton<String>(
      value: locale,
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
        // nếu thêm ngôn ngữ khác thì thêm ở đây
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(localeNotifierProvider.notifier).setLocale(value);
        }
      },
    );
  }
}
