import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/providers/locale_provider.dart';
import '../localization/constants.dart'; // Import để lấy supportedLocales

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);
    final localeNotifier = ref.read(localeNotifierProvider.notifier);

    // Hàm để lấy tên hiển thị của ngôn ngữ
    String getLanguageDisplayName(String localeCode) {
      switch (localeCode) {
        case 'en':
          return 'English';
        case 'vi':
          return 'Tiếng Việt';
        default:
          return localeCode;
      }
    }

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            title: const Text('Chọn ngôn ngữ'),
            actions: supportedLocales.map((localeCode) {
              return CupertinoActionSheetAction(
                onPressed: () {
                  localeNotifier.setLocale(localeCode);
                  Navigator.pop(context);
                },
                child: Text(
                  getLanguageDisplayName(localeCode),
                  style: TextStyle(
                    fontWeight: currentLocale == localeCode
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: currentLocale == localeCode
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.black,
                  ),
                ),
              );
            }).toList(),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
          ),
        );
      },
      child: Text(
        getLanguageDisplayName(currentLocale),
        style: const TextStyle(color: CupertinoColors.activeBlue),
      ),
    );
  }
}
