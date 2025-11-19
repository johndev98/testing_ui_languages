import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/localization_extension.dart';
import 'show_fps.dart';
import 'show_ram.dart';
import 'widgets/language_switch.dart';

class AppBarTitle extends ConsumerWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(ref.translate('genders.title', fallback: 'Chọn giới tính'));
  }
}

class GenderButtons extends ConsumerWidget {
  const GenderButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Thay đổi để phân bố đều hơn
      children: [
        CupertinoButton.filled(
          // Sử dụng CupertinoButton.filled cho nút chính
          onPressed: () {},
          child: Text(ref.translate('genders.male', fallback: 'Nam')),
        ),
        const SizedBox(height: 12),
        CupertinoButton.filled(
          onPressed: () {},
          child: Text(ref.translate('genders.female', fallback: 'Nữ')),
        ),
        const SizedBox(height: 12),
        CupertinoButton(
          // Sử dụng CupertinoButton thường cho nút phụ
          onPressed: () {},
          child: Text(ref.translate('genders.other', fallback: 'Khác')),
        ),
      ],
    );
  }
}

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const AppBarTitle(),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: const LanguageDropdown(),
        ),
      ),
      child: Center(
        // Center the content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center column content
          children: const [
            GenderButtons(),
            SizedBox(height: 20), // Thêm khoảng cách
            AppUsageWidget(), // AppUsageWidget không có trong context, giả định nó là Text
            FpsMonitor(), // FpsMonitor không có trong context, giả định nó là Text
          ],
        ),
      ),
    );
  }
}
